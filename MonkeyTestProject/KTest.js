load("libs/MonkeyProject.js");


MonkeyProject.KTest.prototype.run = function() {
	/**
	 * @type MT.Application
	 */
	var app = this.app;

    for( var i = 1; i <= 10; i++)
    	{
	app.button("_uiHL").tap();
	app.button("hl intro submenu").tap();
	app.button("hl tg submenu").tap();
	app.button("hl tg farm").tap();
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.hLTourGuide("iActiveView").swipe("Left");
	app.uIViewControllerWrapperView().tap();
	app.button("hl intro submenu").tap();
	app.button("gohome btn").tap();
	app.button("_uiSpx").tap();
	app.button("spx plan").tap();
	app.button("spx plan map cinema btn").tap();
	app.button("spx back2map btn").tap();
	app.button("spx plan map greentie btn").tap();
	app.button("spx back2map btn").tap();
	app.button("spx lion").tap({thinktime:"3000"});
	app.button("spx lion horse bigbtn").tap();
	app.button("common cross").tap();
	app.button("gohome btn").tap();
	app.button("_uiVlg").tap();
	app.button("vlg interview").tap();
	app.button("common cross").tap();
	app.uIViewControllerWrapperView().tap();
	app.button("vlg designconcept").tap();
	app.uIViewControllerWrapperView().tap();
	app.uIViewControllerWrapperView().tap();
	app.button("vlg compath").tap();
	app.button("vlg 01 02 btn indoorrun").tap();
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.vlgComPath("iActiveView").swipe("Left");
	app.button("vlg interpub").tap();
	app.button("vlg 01 03 north nail01").tap();
	app.button("common cross").tap();
	app.button("vlg 01 03 south nail01").tap();
	app.button("common cross").tap();
	app.button("vlg 01 03 west nail01").tap();
	app.button("common cross").tap();
	app.button("vlg roomtype").tap();
	app.button("vlg interdeco").tap();
	app.button("gohome btn").tap();
	app.button("_uiVlgFtr").tap();
	app.button("common cross white").tap();
	app.button("vlg smart").tap();
	app.scroller().scroll("0", "1258");
	app.button("vlg service").tap();
	app.scroller().scroll("0", "859");
	app.button("gohome btn").tap();
	app.debug().print(i);
    	}
};