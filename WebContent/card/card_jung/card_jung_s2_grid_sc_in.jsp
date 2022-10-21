<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	
	
	String s_yy = AddUtil.getDate(1);
	
	
	long g_j_jan = 0;    
		
	JSONArray jarr = new JSONArray();
	
	jarr = CardDb.getCardJungDtStatINewJson(dt, ref_dt1, ref_dt2, br_id, dept_id, user_nm);
	
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	long t_amt1[] = new long[1];
	long t_amt2[] = new long[1];
	long t_amt3[] = new long[1];
	long t_amt4[] = new long[1];
	long t_amt5[] = new long[1];
	long t_amt6[] = new long[1];
	long t_amt7[] = new long[1];
	long t_amt8[] = new long[1];
	long t_amt9[] = new long[1];
	long t_amt10[] = new long[1];
	long t_amt11[] = new long[1];  //budget_amt 
	long t_amt12[] = new long[1];  //g4_amt - 복지비 
	long t_amt13[] = new long[1];  //g_2_4_amt - 정산누계 
	long t_amt15[] = new long[1];  //g_15 - 경조사 
	long t_amt14[] = new long[1];  //t_basic_amt - 중식기준액 
	
	long t_amt16[] = new long[1];  //기타 한도 (팀장이상) ebudget_amt
		
	long t_amt30[] = new long[1];  //g30_amt - 포상휴가 
	
	String nn= "";
	
	String jobjString = "";

	int k =  0;
	
	JSONObject jObj = new JSONObject();
		
	if(jarr_size > 0) {
		
		jobjString = "data={ rows:[ ";
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			JSONObject ht = (JSONObject)jarr.get(i);
					
 			nn =(String) ht.get("DEPT_NM");
 			
			/*
			for(int j=0; j<1; j++){
				
				t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("BASIC_AMT")));
				t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")));
				t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT")));
				t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("T_REAL_AMT")));
				t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")));
				t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
				t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")));
				t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")));
				t_amt10[j] += AddUtil.parseLong(AddUtil.sl_th_rnd(String.valueOf(ht.get("REMAIN_AMT"))));
				t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
				t_amt12[j] += AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")));
				t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
				t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
				t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("T_BASIC_AMT")));  
				t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")));  
				
			}
		*/		
			long tot = 0;
		    tot = AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G30_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));  
		    
		    long b_tot = 0;
		    b_tot = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));  
		    
		    long s_tot = 0;  //근속포상비
		    s_tot = AddUtil.parseLong(String.valueOf(ht.get("SBUDGET_AMT")));  
		    
	//	    long j_tot=0;
	//	    j_tot = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))- AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
		    
		    long j_jan=0;
			   
			if ( AddUtil.parseInt(s_yy) > 2016 ) {
			    
			    if (ht.get("USER_ID").equals("000003") || ht.get("USER_ID").equals("000004") || ht.get("USER_ID").equals("000005")  || ht.get("USER_ID").equals("000237")   || ht.get("USER_ID").equals("000026")   || ht.get("USER_ID").equals("000028")   ) {
			        j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("SBUDGET_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
			    } else {
			         j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("SBUDGET_AMT"))) +  AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))) +  AddUtil.parseLong(String.valueOf(ht.get("T_BASIC_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("T_REAL_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
			    } 
			    
	   	    } else {
	   	    	   if (ht.get("USER_ID").equals("000003") || ht.get("USER_ID").equals("000004") || ht.get("USER_ID").equals("000005")    ) {
			        j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("SBUDGET_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
			    } else {
			         j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("SBUDGET_AMT")))+  AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))) +  AddUtil.parseLong(String.valueOf(ht.get("T_BASIC_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("T_REAL_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
			    } 
	   	    	   	    
	   	    } 
	   	    
			g_j_jan += j_jan;  
			
			// 복지비 + 경조사 + 포상휴가
			long  w_tot = 0;  //경조사제외 - 복지비 (20161215)
	//		w_tot = AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")));  
			w_tot = AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+  AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")));  
			
			if(i != 0 ){
				jobjString += ",";
			}	
			k =  i+1;
			jobjString +=  " { id:" + k + ",";
			jobjString +=  "data:[\""  +  k + "\",";//연번
			jobjString +=  "\"" + nn + "\",";//부서
			jobjString +=  "\"" + ht.get("USER_POS") + "\",";//직급
			//jobjString +=  "\"" +  + "\",";//내역보기
			
			if(String.valueOf(ht.get("USER_ID")).equals(ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ck_acar_id.equals("000003") ||  ck_acar_id.equals("000004")  ){				
				jobjString +=  "\"" + ht.get("USER_NM") +"^javascript:MM_openBrWindow(&#39;card_jung_sc_in.jsp?work_nm="+ht.get("USER_NM")+"&work="+ht.get("W_CNT")+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+"&auth_rw=1&user_id="+ht.get("USER_ID")+"&br_id="+ht.get("BR_ID")+"&#39;,&#39;popwin_vacation&#39;,&#39;scrollbars=yes,status=no,resizable=yes,width=960,height=700,top=20,left=20&#39;);^_self\",";//성명
			}else{
				jobjString +=  "\"" + ht.get("USER_NM") +"\",";//성명
			}
			
			jobjString +=  "\"" + String.valueOf(ht.get("W_CNT")) + "\",";//근무일수	
			jobjString +=  "\"" + String.valueOf(ht.get("BASIC_AMT")) + "\",";//중식기준액
			jobjString +=  "\"" + b_tot + "\",";//회식비
			jobjString +=  "\"" + s_tot + "\",";//근속포상비
			jobjString +=  "\"" + String.valueOf(ht.get("EBUDGET_AMT")) + "\",";//중식기준액
			jobjString +=  "\"" + String.valueOf(ht.get("G2_1_AMT")) + "\",";//조식
			jobjString +=  "\"" + String.valueOf(ht.get("REAL_AMT")) + "\",";//중식
			jobjString +=  "\"" + String.valueOf(ht.get("G2_3_AMT")) + "\",";//특근식
			jobjString +=  "\"" + w_tot + "\",";//복지비		
			jobjString +=  "\"" + String.valueOf(ht.get("G3_AMT")) + "\",";//기타			
			jobjString +=  "\"" + tot + "\",";//합계
			jobjString +=  "\"" + String.valueOf(ht.get("T_REAL_AMT")) + "\",";//중식누계금액
			jobjString +=  "\"" + String.valueOf(ht.get("G_2_4_AMT")) + "\",";//복지비누계금액
			jobjString +=  "\"" + String.valueOf(ht.get("G_3_4_AMT")) + "\",";//기타누계금액
			jobjString +=  "\"" + j_jan + "\"] ";//정산차액
			
			jobjString += "}";
		}
	}
	jobjString += "]};";

%>

<!DOCTYPE HTML>
<html>
<head>
	<title>Untitled Document</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
	<!--link rel="stylesheet" type="text/css" href="/include/table_t.css"-->
	
	<!--Grid-->
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
	<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid.css"/>
	<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
	<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
	<!--Grid-->
	
	<script>
	<%=jobjString%>
	</script>
	
	<script>
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

   
    
	function parsingGridData(){
		 var myGrid;   
	    myGrid = new dhtmlXGridObject('gridbox');
	    myGrid.setImagePath(""); 
	    myGrid.setHeader("연번,부서,직급,성명,근무<br>일수,중식<br>기준액,복리후생<br>기준액,#cspan,팀장활동비<br>기준액,항목,#cspan,#cspan,#cspan,#cspan,#cspan,중식<br>누계금액,복리후생<br>누계금액,팀장활동비<br>누계금액,정산<br>차액"); 
	    myGrid.setInitWidths("40,80,75,70,50,90,85,90,90,85,85,85,85,85,85,90,90,90,80"); 	
	    myGrid.setColSorting("int,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,int");     
	    myGrid.setColTypes("ro,ro,ro,link,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron");//총0-18열(19개), 5열부터 금액 	
	    myGrid.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,회식비,특별,#rspan,조식,중식,특근식,복리후생,팀장활동비,합계,#rspan,#rspan,#rspan,#rspan");
	    myGrid.setColAlign("center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,right,right,right");
	    myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false");
	    myGrid.setNumberFormat("0,000",5);
	    myGrid.setNumberFormat("0,000",6);
	    myGrid.setNumberFormat("0,000",7);
	    myGrid.setNumberFormat("0,000",8);
	    myGrid.setNumberFormat("0,000",9);
	    myGrid.setNumberFormat("0,000",10);
	    myGrid.setNumberFormat("0,000",11);
	    myGrid.setNumberFormat("0,000",12);
	    myGrid.setNumberFormat("0,000",13);
	    myGrid.setNumberFormat("0,000",14);
	    myGrid.setNumberFormat("0,000",15);	  
	    myGrid.setNumberFormat("0,000",16);	 
	    myGrid.setNumberFormat("0,000",17);	 
	    myGrid.setNumberFormat("0,000",18);	 
	    //myGrid.objBox.style.overflowY = "overlay";
	   
	    myGrid.init();
	    
	    eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	    //myGrid.attachFooter("합계,#cspan,#cspan,#cspan,-,<div id='lunch_std'>0</div>,<div id='welf_std'>0</div>,<div id='breakf'>0</div>,<div id='lunch'>0</div>,<div id='dinner'>0</div>,<div id='welf'>0</div>,<div id='event'>0</div>,<div id='etc'>0</div>,<div id='reward'>0</div>,<div id='total'>0</div>,<div id='lunch_total'>0</div>,<div id='welf_total'>0</div>,<div id='calcu'>0</div>",["text-align:center;","text-align:center;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;"]);
	    myGrid.attachFooter("합계,#cspan,#cspan,#cspan,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,",["text-align:center;","text-align:center;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;","text-align:right;"]);
	    myGrid.splitAt(5);
	   // myGrid.enableBlockSelection();
	    myGrid.enableMathEditing(true);
	    myGrid.enableColumnMove(false);      
	    myGrid.enableSmartRendering(false);
	    myGrid.forceLabelSelection(true);
	    myGrid.parse(data,"json");	    
	   
	}
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
				myGrid.setCSVDelimiter("\t");
				
				myGrid.copyBlockToClipboard()
			}
			if(code==86&&ctrl){
				myGrid.setCSVDelimiter("\t");
				myGrid.pasteBlockFromClipboard()
			}
		return true;
	}

	/* function calculateFooterValues(stage){
		if(stage && stage!=2)
			return true;
		var lcS = document.getElementById("lunch_std");
			lcS.innerHTML = sumColumn(5);
		var wfS = document.getElementById("welf_std");
			wfS.innerHTML = sumColumn(6);
		var bf = document.getElementById("breakf");
			bf.innerHTML = sumColumn(7);
		var lc = document.getElementById("lunch");
			lc.innerHTML = sumColumn(8);
		var dn = document.getElementById("dinner");
			dn.innerHTML = sumColumn(9);
		var wf = document.getElementById("welf");
			wf.innerHTML = sumColumn(10);
		var evt = document.getElementById("event");
			evt.innerHTML = sumColumn(11);
		var etC = document.getElementById("etc");
			etC.innerHTML = sumColumn(12);
		var rw = document.getElementById("reward");
			rw.innerHTML = sumColumn(13);
		var tt = document.getElementById("total");
			tt.innerHTML = sumColumn(14);
		var lcT = document.getElementById("lunch_total");
			lcT.innerHTML = sumColumn(15);
		var wfT = document.getElementById("welf_total");
			wfT.innerHTML = sumColumn(16);
		var cc = document.getElementById("calcu");
			cc.innerHTML = sumColumn(17);
		return true;
	}
	function sumColumn(ind){
		var out = 0;
		for(var i=0;i<myGrid.getRowsNum();i++){
			out+= parseFloat(myGrid.cells2(i,ind).getValue())
		}
		return out;
	}	 */
	</script>
</head>
<body onload="javascript:parsingGridData();">
	<div id="gridbox" style="width:99%;height:600px;"></div>
</body>
</html>
