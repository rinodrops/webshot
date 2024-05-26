# WebShot - Website Screenshot Capture Tool

WebShot is a command-line tool for capturing screenshots of websites using Selenium WebDriver. It allows users to configure various options, such as screenshot dimensions, delays, scrolling behavior, and authentication.

## Features

- Capture full-page screenshots of websites
- Support for multiple screenshot configurations
- Customizable screenshot dimensions, delays, and scrolling behavior
- Automatically generate screenshot filenames based on URLs
- Integration with authentication mechanisms
- Cookie handling for session management
- Configurable through YAML files or command-line arguments

## Prerequisite

Before running WebShot, ensure that you have the following prerequisites:

- Unix-based operating system (e.g., macOS, Linux)
- Python 3.x
- Google Chrome web browser
- ChromeDriver

### Installing ChromeDriver

WebShot uses Selenium WebDriver to automate the Chrome browser to capture screenshots. To use Selenium with Chrome, you need to install ChromeDriver. Follow these steps to set it up:

1. Visit the [ChromeDriver downloads page](https://developer.chrome.com/docs/chromedriver/downloads)
2. Download the ChromeDriver version that matches your installed Chrome browser version.
3. Extract the downloaded archive and place the `chromedriver` executable in a directory accessible from your system's PATH.
4. Make sure the `chromedriver` executable has the necessary permissions to be executed.

## Installation

Clone the repository, navigate to the project directory, and install the required Python dependencies:

```sh
$ git clone https://github.com/rinodrops/webshot.git
$ cd webshot
$ pip install -r requirements.txt
```

- You may want to create a virtual environment.
- You can move `webshot` anywhere (e.g., `/usr/local/bin`) for site-wide availability.

## Usage

You can provide a YAML configuration file or specify the necessary options through command-line arguments to capture screenshots. Note that a YAML file must be used to provide configuration related to the login procedure due to security concerns.

### Using a YAML Configuration File

Create a YAML configuration file (e.g., `config.yaml`) with the desired screenshot configurations.

Run the script with the YAML configuration file:

```sh
$ webshot -c config.yaml
```

#### Screenshots URL and Its Filename

Create a key named `screenshots` in the YAML file. Specify the URL and its filename. You may list multiple items.

| Item            | Description                                                                                                             | Default      |
| --------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------ |
| `url`           | The URL of the web page to capture a screenshot of.                                                                     |              |
| `filename`      | The filename to save the captured screenshot as. If not provided, a filename will be generated based on the `url`.      |              |

Here's an example:

```yaml
screenshots:
  - url: https://example.com/page1
    filename: page1.png
  - url: https://example.com/page2
    filename: page2.png
```

#### Screenshots-related items

You may provide additional information. If you specify them at the global level (e.g., the same level as the `screenshots`), they are applied to every item listed in the `screenshots`. If you specify them at the item level (e.g., the same level as each item), they are applied to the specific item.

| Item            | Description                                                                                                             | Default      |
| --------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------ |
| `output_dir`    | The directory where the captured screenshots will be saved.                                                             | .            |
| `width`         | The width of the browser window for capturing screenshots.                                                              | 1920         |
| `delay`         | The delay (in seconds) before capturing the screenshot, allowing the page to load.                                      | 3            |
| `max_height`    | The maximum height of the screenshot. If the page height exceeds this value, the script will stop scrolling.            | 10000        |
| `scroll_delay`  | The delay (in seconds) between each scroll step, allowing dynamic content to load.                                      | 3            |
| `scroll_step`   | The size of each scroll step (in pixels) when scrolling through the page.                                               | 1200         |
| `content_xpath` | The XPath of the scrollable content element on the page. If not provided, the entire `<body>` element will be scrolled. | `/html/body` |
| `offset_height` | The height of the non-scrollable offset area at the top of the page.                                                    | (None)       |

```yaml
output_dir: screenshots
delay: 1
screenshots:
  - url: https://example.com/page1
    filename: page1.png
    width: 1920
  - url: https://example.com/page2
    filename: page2.png
    width: 1600
    scroll_step: 300
    content_xpath: //*[@id="scrollable"]
```

#### Login-related Items

You may specify login-related items at the global level if the target pages are password-protected.

| Item             | Description                                                                                                             | Default      |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------ |
| `login_url`      | The URL of the login page.                                                                                              | (None)       |
| `login_delay`    | The delay (in seconds) after a successful login, allowing the page to load.                                             | 3            |
| `cookie_file`    | The file path where cookies will be saved after a successful login and loaded for subsequent requests.                  | (None)       |
| `username_xpath` | The XPath of the username input field on the login page.                                                                | `//*[@id="username"]` |
| `password_xpath` | The XPath of the password input field on the login page.                                                                | `//*[@id="password"]` |
| `submit_xpath`   | The XPath of the submit button on the login page.                                                                       | (None)       |
| `username`       | The username for logging in.                                                                                            | (None)       |
| `password`       | The password for logging in.                                                                                            | (None)       |


Here's an example:

```yaml
output_dir: screenshots
width: 1920
max_height: 10000
delay: 3
scroll_delay: 3
scroll_step: 1200

login_url: https://example.com/login
submit_xpath: //*[@id="login-button"]
username: your_username
password: your_password
login_delay: 5

cookie_file: cookies.json

screenshots:
  - url: https://example.com/page1
    filename: page1.png
  - url: https://example.com/page2
    filename: page2.png
    content_xpath: //*[@id="content"]
```

### Using Command-Line Arguments

You can also specify the screenshot configuration directly through command-line arguments:

```
webshot https://example.com/page -o output.png -W 1920 -D 3 -H 10000 -S 3 -T 1200
```

Usage with Command Line:

```bash
# Capture a screenshot using a YAML configuration file
python webshot.py -c config.yaml

# Capture a screenshot using command-line arguments
python webshot.py https://example.com/page -o output.png -W 1920 -D 3 -H 10000 -S 3 -T 1200

# Display help and available command-line arguments
python webshot.py -h
```


For more information on the available command-line arguments, run: `webshot -h`

```
usage: webshot [-h] [-c CONFIG] [-o OUTPUT] [-v] [-W WIDTH] [-D DELAY] [-H MAX_HEIGHT] [-S SCROLL_DELAY]
               [-T SCROLL_STEP] [-X CONTENT_XPATH] [-O OFFSET_HEIGHT] [--cookie-file COOKIE_FILE]
               [url]

Capture website screenshots

positional arguments:
  url                   URL of the target webpage

options:
  -h, --help            show this help message and exit
  -c CONFIG, --config CONFIG
                        Config file path (YAML)
  -o OUTPUT, --output OUTPUT
                        Output file path for the screenshot
  -v, --verbose         Enable verbose output (-v info, -vv debug)
  -W WIDTH, --width WIDTH
                        Screenshot width
  -D DELAY, --delay DELAY
                        Delay before capturing the screenshot (in seconds)
  -H MAX_HEIGHT, --max-height MAX_HEIGHT
                        Maximum height of the screenshot
  -S SCROLL_DELAY, --scroll-delay SCROLL_DELAY
                        Delay between each scroll step (in seconds)
  -T SCROLL_STEP, --scroll-step SCROLL_STEP
                        Scroll step size (in pixels)
  -X CONTENT_XPATH, --content-xpath CONTENT_XPATH
                        XPath of the scrollable content element
  -O OFFSET_HEIGHT, --offset-height OFFSET_HEIGHT
                        Height of the non-scrollable offset area
  --cookie-file COOKIE_FILE
                        File path to save and load cookies
```

## License

This project is licensed under the [MIT License](LICENSE).
