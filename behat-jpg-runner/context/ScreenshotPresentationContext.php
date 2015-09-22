<?php

namespace ExtremelyDefensivePhpTest;

use Behat\Behat\Context\Context;
use Behat\Mink\Driver\Selenium2Driver;
use Behat\Mink\Session;

/**
 * Indeed, as per @CiaranMcNulty, this stuff could indeed just be a script using Mink and the Selenium2Driver DIRECTLY.
 */
final class ScreenshotPresentationContext implements Context
{
    /**
     * @var Session
     */
    private $session;

    public function __construct()
    {
        $driver  = new Selenium2Driver(/*'chrome', null, 'http://localhost:8643/wd/hub'*/);
        // note: no DI needed here (for now)
        $session = new Session($driver);

        $session->start();
        $driver->resizeWindow(1280, 720);

        $this->session = $session;
    }

    /**
     * @When I load the presentation
     */
    public function loadThePresentation()
    {
        $this->session->visit('http://localhost:9001');
    }

    /**
     * @When I can go to the next slide until there are slides left
     */
    public function iCanGoToTheNextSlideUntilThereAreSlidesLeft()
    {
        $page       = $this->session->getPage();
        $pageNumber = 0;

        while ($next = $page->find('css', '.navigate-right.enabled')) {
            // @todo could be more elegant and wait for the URI hash to change here.
            sleep(1);

            // take screenshot here
            file_put_contents(__DIR__ . '/../build/' . $pageNumber . '.jpg', $this->session->getScreenshot());

            $next->click();

            $pageNumber += 1;
        }
    }
}
