
class dialogTeleport
{
	idd = 17041;
	class controls 
	{
		class frame: RscText
		{
			idc = -1;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.211406 * safezoneW;
			h = 0.484 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class textTitle: RscText
		{
			idc = -1;
			text = "TELEPORT TO PLAYER"; 
			x = 0.45875 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.066 * safezoneH;
		};
		class RscListbox_1500: RscListbox
		{
			idc = 170411;
			x = 0.443281 * safezoneW + safezoneX;
			y = 0.324 * safezoneH + safezoneY;
			w = 0.118594 * safezoneW;
			h = 0.297 * safezoneH;
		};
		class btnClose: RscButton
		{
			idc = -1;
			text = "CLOSE"; 
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.044 * safezoneH;
			action = "closedialog 0";
		};
		class btnTeleport: RscButton
		{
			idc = 170412;
			text = "TELEPORT"; 
			x = 0.4175 * safezoneW + safezoneX;
			y = 0.676 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};



class dialogArty
{
	idd = 04051;
	class controls 
	{
		class frame: RscText
		{
			idc = -1;
			x = 0.267969 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.484688 * safezoneW;
			h = 0.418 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class btnOrder: RscButton
		{
			idc = 040511;
			text = "FIRE FOR EFFECT"; //--- ToDo: Localize;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Order the artillery barrage with the given coordinates, don't hesitate to fire smoke first to adjust your shot"; //--- ToDo: Localize;
			action = "execVM 'scripts\arty\order_arty.sqf';";
		};
		class btnClose: RscButton
		{
			idc = -1;
			text = "CLOSE"; //--- ToDo: Localize;
			x = 0.670156 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.0567187 * safezoneW;
			h = 0.044 * safezoneH;
			action = "closedialog 0";
		};
		class editX: RscEdit
		{
			idc = 040512;
			text = "000"; //--- ToDo: Localize;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class editY: RscEdit
		{
			idc = 040513;
			text = "000"; //--- ToDo: Localize;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class textX: RscText
		{
			idc = -1;
			text = "X"; //--- ToDo: Localize;
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class textY: RscText
		{
			idc = -1;
			text = "Y"; //--- ToDo: Localize;
			x = 0.520625 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class textCoord: RscText
		{
			idc = -1;
			text = "Coordinates"; //--- ToDo: Localize;
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.423 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class lbPieces: RscListbox
		{
			idc = 040514;
			x = 0.288594 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.242 * safezoneH;
		};
		class textPieces: RscText
		{
			idc = -1;
			text = "Available pieces"; //--- ToDo: Localize;
			x = 0.309219 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class editShots: RscEdit
		{
			idc = 040515;
			text = "0"; //--- ToDo: Localize;
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class textShots: RscText
		{
			idc = -1;
			text = "Shots per gun"; //--- ToDo: Localize;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.0670312 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class lbAmmo: RscListbox
		{
			idc = 040516;
			x = 0.412344 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.108281 * safezoneW;
			h = 0.242 * safezoneH;
		};
		class textAmmo: RscText
		{
			idc = -1;
			text = "Available ammo types"; //--- ToDo: Localize;
			x = 0.422656 * safezoneW + safezoneX;
			y = 0.335 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.033 * safezoneH;
		};
		/*
		class btnAdjust: RscButton
		{
			idc = 040517;
			text = "FIRE ADJUSTING ROUND"; //--- ToDo: Localize;
			x = 0.412344 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Fire 1 smoke round to adjust the coordinates"; //--- ToDo: Localize;			
		};
		*/
		class editDist: RscEdit
		{
			idc = 040518;
			text = "0"; //--- ToDo: Localize;
			x = 0.665 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class editAngle: RscEdit
		{
			idc = 040519;
			text = "0"; //--- ToDo: Localize;
			x = 0.665 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class textAdjust: RscText
		{
			idc = -1;
			text = "Adjustments"; //--- ToDo: Localize;
			x = 0.680469 * safezoneW + safezoneX;
			y = 0.423 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class textDist: RscText
		{
			idc = -1;
			text = "Distance"; //--- ToDo: Localize;
			x = 0.62375 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class textAngle: RscText
		{
			idc = -1;
			text = "Angle"; //--- ToDo: Localize;
			x = 0.628906 * safezoneW + safezoneX;
			y = 0.533 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.044 * safezoneH;
		};
	};
};


