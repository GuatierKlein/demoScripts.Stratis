
sleep 10;

while {true} do {
	switch (GDGM_climate_type) do {
		//temperate
		case 1: {
			60 setOvercast (random [0,0.35,1]);
			//60 setRain (random [0,0,1]);			
		};
		//arid
		case 2: {
			60 setOvercast (random [0,0,0.5]);
			60 setRain 0;	
		};
		case 3: {};
		case 4: {};
	};

	sleep (random [1200,2500,3600]);
};
