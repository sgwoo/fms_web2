<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String dt		= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	
	Vector jarr = olcD.getSuiStatLst(dt, ref_dt1, ref_dt2, gubun1, gubun2, gubun3, s_kd, t_wd);
	int jarr_size = jarr.size();
	
	String jobjString = "";
	int k =  0;
	
	if(jarr_size >= 0 ) {
		
		jobjString = "data={ rows:[ ";

		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			if(i != 0 ){
				jobjString += ",";
			}	
			
			k =  i+1;
	 	 	jobjString +=  " { id:" + k + ",";
	 	 	jobjString +=  "data:[\""  +  k + "\",";//연번 0
	 	 	
	 	 	jobjString +=  "\""+ht.get("CAR_NO") + "\",";//차량번호 1
	 	 	jobjString +=  "\""+ht.get("JG_CODE") + "\",";//차종코드 2
			jobjString +=  "\""+String.valueOf(ht.get("CAR_NAME")) + "\",";//차명 3
			jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT"))) + "\",";//최초등록일 4	 	 	
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT"))) + "\",";//매각일자 5
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_MON"))) + "\",";//매각월 6
	 	 	jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT1")) + "\",";//신차소비자가 7
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CAR_MON")),2) + "\",";//차령 8	
	 	 	
	 	 	//20210915 추가
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("M_VAR")),2) + "\",";//실질잔가손익율 9
	 	 	jobjString +=  "\""+String.valueOf(ht.get("N_VAR")) + "\",";//실질잔가손익 10
	 	 	
	 	 	//잔가손익
	 	 	jobjString +=  "\""+String.valueOf(ht.get("TOT_PNL_AMT")) + "\",";//잔가총손익 11
	 	 	jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("TOT_PNL_PER")),2) + "\",";//신차소비자가격대비 12
	 	 	jobjString +=  "\""+String.valueOf(ht.get("T_PNL_AMT")) + "\",";//잔가손익합계 13
	 	 	
	 	 	if(AddUtil.parseInt(String.valueOf(ht.get("J_OVER_AMT"))) < 0 ){
	 	 		jobjString +=  "\""+"0" + "\",";//초과운행대여료합계 14
	 	 		jobjString +=  "\""+(AddUtil.parseInt(String.valueOf(ht.get("J_OVER_AMT")))*-1) + "\",";//환급대여료합계 15
	 	 	}else{
	 	 		jobjString +=  "\""+String.valueOf(ht.get("J_OVER_AMT")) + "\",";//초과운행대여료합계 14
	 	 		jobjString +=  "\""+"0" + "\",";//환급대여료합계 15
	 	 	}
	 	 	
	 		//jobjString +=  "\""+String.valueOf(ht.get("BC_B_D")) + "\",";//재리스초기영업비용견적반영분 13
	 	 	//jobjString +=  "\""+String.valueOf(ht.get("J_SERV_AMT")) + "\",";//재리스실수리비 14
	 	 	
	 		jobjString +=  "\""+String.valueOf(ht.get("COMM_AMT")) + "\",";//매각수수료합계(낙찰/출품/재출품수수료/중개수수료/탁송료) 15
	 		//참고 중고차평가이익
	 		jobjString +=  "\""+String.valueOf(ht.get("AMT5")) + "\",";//중고차평가이익 추가 16
	 		//기타 대여기간
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON1")),2) + "\",";//장기계약 잔가손익 비교시 미포함 대여기간(참고값) 17
	 		
	 		//20210915 추가
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("L_VAR")),2) + "\",";//미포함기간잔가손익효과 18
	 		
	 		//20211021 추가
	 		jobjString +=  "\""+String.valueOf(ht.get("L_VAR_AMT")) + "\",";//미포함기간잔가손익효과 금액(신차소비자가격대비) 19
	 		
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON2")),2) + "\",";//적용잔가 재계산없는 추가이용기간 20
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CONT_MON3")),2) + "\",";//월렌트 대여기간 21	 		
	 		//신차 (매입옵션 있는 신차 연장건 포함)
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT1"))) + "\",";//대여개시일 22
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT1"))) + "\",";//대여만료일 23
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON1")) + "\",";//계약상 대여기간 24
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON1")),2) + "\",";//실제 대여기간 25
	 		jobjString +=  "\""+ht.get("JAN_ST1") + "\",";//적용잔가 참조 DATA 26
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT1")) + "\",";//적용잔가 27
	 		//매입옵션 없는 신차 연장
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT2")) + "\",";//연장계약시점 중고차가(최종연장계약건만표기) 28
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT2")) + "\",";//신차연장손익 29
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT2"))) + "\",";//대여개시일 30
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT2"))) + "\",";//대여만료일 31
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON2")) + "\",";//계약상 대여기간 32
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON2")),2) + "\",";//실제 대여기간 33
	 		jobjString +=  "\""+ht.get("JAN_ST2") + "\",";//적용잔가 참조 DATA 34
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT2")) + "\",";//적용잔가 35
	 		//재리스1 (매입옵션 있는 재리스 연장 건 포함, 재리스최초계약)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT3")) + "\",";//재리스 계약시점 중고차가(최초계약) 36
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT3")) + "\",";//재러스1 손익(최초계약) 37
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT3"))) + "\",";//대여개시일 38
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT3"))) + "\",";//대여만료일 39
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON3")) + "\",";//계약상 대여기간 40
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON3")),2) + "\",";//실제 대여기간 41
	 		jobjString +=  "\""+ht.get("JAN_ST3") + "\",";//적용잔가 참조 DATA 42
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT3")) + "\",";//적용잔가 43
	 		//재리스1 (매입옵션 없는 재리스 연장, 재리스최초계약의 연장)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT4")) + "\",";//재리스1 연장 계약시점 중고차가(최초계약) 44
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT4")) + "\",";//재러스1 연장 손익(최초계약) 45
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT4"))) + "\",";//대여개시일 46
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT4"))) + "\",";//대여만료일 47
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON4")) + "\",";//계약상 대여기간 48
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON4")),2) + "\",";//실제 대여기간 49
	 		jobjString +=  "\""+ht.get("JAN_ST4") + "\",";//적용잔가 참조 DATA 50
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT4")) + "\",";//적용잔가 51
	 		//재리스2~5 (매입옵션 있는 재리스 연장 건 포함)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT5")) + "\",";//재리스2~5 계약시점 중고차가 52
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT5")) + "\",";//재러스2~5 손익 53
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT5"))) + "\",";//대여개시일 54
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT5"))) + "\",";//대여만료일 55
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON5")) + "\",";//계약상 대여기간 56
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON5")),2) + "\",";//실제 대여기간 57
	 		jobjString +=  "\""+ht.get("JAN_ST5") + "\",";//적용잔가 참조 DATA 58
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT5")) + "\",";//적용잔가 59
	 		//재리스2~5 (매입옵션 없는 재리스 연장)
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_AMT6")) + "\",";//재리스2~5 연장 계약시점 중고차가(최초계약) 60
	 		jobjString +=  "\""+String.valueOf(ht.get("PNL_AMT6")) + "\",";//재러스2~5 연장 손익(최초계약) 61
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT6"))) + "\",";//대여개시일 62
	 		jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT6"))) + "\",";//대여만료일 63
	 		jobjString +=  "\""+String.valueOf(ht.get("CON_MON6")) + "\",";//계약상 대여기간 64
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("R_CON_MON6")),2) + "\",";//실제 대여기간 65
	 		jobjString +=  "\""+ht.get("JAN_ST6") + "\",";//적용잔가 참조 DATA 66
	 		jobjString +=  "\""+String.valueOf(ht.get("JAN_AMT6")) + "\",";//적용잔가 67
	 		//매각
	 		jobjString +=  "\""+ht.get("END_ST") + "\",";//최종계약 68
	 		jobjString +=  "\""+ht.get("END_TYPE") + "\",";//매각방식(경매/매입옵션) 69
	 		jobjString +=  "\""+String.valueOf(ht.get("END_JAN_AMT")) + "\",";//최종 계약의 적용잔가 70
	 		jobjString +=  "\""+String.valueOf(ht.get("MM_PR")) + "\",";//매도가 71
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("MM_PER")),2) + "\",";//신차소비자가 대비 72
	 		jobjString +=  "\""+String.valueOf(ht.get("MM_PNL_AMT")) + "\",";//매각손익(최종 계약 적용잔가 기준) 73
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("CAR_MON2")),2) + "\",";//차령 74
	 		jobjString +=  "\""+String.valueOf(ht.get("CAR_KM")) + "\",";//주행거리 75
	 		jobjString +=  "\""+ht.get("ACTN_JUM") + "\",";//경매장 평점 76
	 		jobjString +=  "\""+ht.get("MIGR_ST") + "\",";//명의이전구분 77
	 		jobjString +=  "\""+String.valueOf(ht.get("A_SERV_AMT")) + "\",";//사고수리비 78
	 		jobjString +=  "\""+ht.get("CAR_NUM") + "\",";//차대번호 79
	 		jobjString +=  "\""+ht.get("JA_MON") + "\",";//자산양수개월수 80
	 		jobjString +=  "\""+ht.get("CAR_CNG_YN") + "\",";//폐차사해지(해당1,미해당0) 81
	 		jobjString +=  "\""+ht.get("JG_2") + "\"]";//일반승용LPG여부(해당1,미해당0) 82
	 		
	 	 	jobjString += "}";
		}	
		jobjString += "]};";
	} 
	
%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0; }
	table.hdr td {	height: 30px !important;	}
</style>
<!--Grid-->
<script>
<%=jobjString%>
</script>
<script language="JavaScript">
<!--
	function sui_help_cont(){
		var SUBWIN= "view_stat_sui_help.jsp";
		window.open(SUBWIN, "View_Help", "left=50, top=50, width=1300, height=900, resizable=yes, scrollbars=yes");
	}
//-->
</script>
</head>
<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100% height="35px">
	<tr>
		<td>
		   <a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
		</td>        
    </tr>
</table>
<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * 총 건수 : <span id="gridRowCount">0</span>건  &nbsp;&nbsp; <a href='javascript:sui_help_cont()' title='설명문'><img src=/acar/images/center/button_exp.gif border=0 align=absmiddle></a>
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="70%" align="right" style="font-size: 9pt;">
        	<span>* 신차등록일 2009년1월1일부터 * 차종변경/계약승계/적용잔가0/폐차사고해지/업무대여 차량 제외</span>
        </td>
    </tr>    
</table>
</body>

<script>

var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//총0-79열(80개)
	
	//헤더레이블
	myGrid.setHeader    ("연번,차량번호,차종코드,차명,신차등록일,매각일자,매각월,신차소비자가격,차령,잔가손익,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,참고,장기계약 잔가손익 산출시 미포함 기간 및 잔가 손익효과,#cspan,#cspan,적용잔가 재계산없는 임의 이용기간,월렌트 대여기간,신차 (매입옵션 있는 신차 연장 건 포함),#cspan,#cspan,#cspan,#cspan,#cspan,매입옵션 없는 신차 연장,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,재리스1 (매입옵션 있는 재리스 연장 건 포함) (재리스 최초계약),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,매입옵션 없는 재리스1 연장 (재리스 최초계약의 연장),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,재리스2~5 (매입옵션 있는 재리스 연장 건 포함),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,매입옵션 없는 재리스2~5 연장,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,최종계약,매각방식,매각,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,차대번호,자산양수개월수,폐차사고해지(해당1),일반승용LPG여부(해당1)");
	//열 너비를 픽셀 단위로 설정
	myGrid.setInitWidths("40,80,80,150,90,90,70,105,50,70,100,100,70,100,100,100,100,100,70,70,100,70,70,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,90,90,90,90,80,80,80,100,100,80,100,100,70,90,50,70,60,80,100,150,70,80,80");
	//정렬유형(str,int,date,na) : 숫자 int,문자 str
	myGrid.setColSorting("int,str,str,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,int,int,int,str,str,int,int,int,int,int,int,str,str,int,str,int,int,int");
	//열 유형(dyn,ed,txt,price,ch,coro,ra,ro) : 읽기전용숫자셀 ron,읽기전용셀 ro //표준편집가능셀ed,텍스트편집가능셀edtxt,편집가능숫자셀edn
	myGrid.setColTypes  ("ro,ro,ron,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ro,ro,ron,ron,ron,ron,ron,ron,ro,ro,ron,ro,ron,ron,ron");
	//헤더추가행
	myGrid.attachHeader ("#rspan,#text_filter,#select_filter,#text_filter,#text_filter,#text_filter,#select_filter,#rspan,#rspan,실질 잔가손익율,실질 잔가손익,잔가손익=(A)+(B)-(C)-(D),신차 소비자 가격대비,장기대여 잔가손익(A),초과운행 대여료(B),환급대여료(C),매각수수료(D),재리스/연장계약 중고차평가이익,잔가손익 미포함기간(개월),미포함기간 잔가손익 효과,미포함기간 잔가손익 효과 금액(신차 소비자가격대비),#rspan,#rspan,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,연장계약시점 견적적용 중고차가,신차연장손익,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,재리스 계약시점 견적적용 중고차가,재리스1 손익,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,재리스1연장 계약시점 견적적용 중고차가,재리스1 연장손익,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,재리스2~5 계약시점 견적적용 중고차가,재리스2~5 손익,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,재리스2~5 연장계약시점 견적적용 중고차가,재리스2~5 연장손익,대여개시일,대여만료일,계약상 대여기간,실제 대여기간,적용잔가 참조DATA,적용잔가,#select_filter,#select_filter,최종계약의 적용잔가,매도가,신차 소비자가 대비,매각손익 (최종계약 적용잔가 기준),차령,주행거리,경매장 평점,명의이전 구분,사고수리비,#text_filter,#rspan,#rspan,#select_filter");
	//열의값 정렬(right,left,center,justify)
	myGrid.setColAlign  ("center,center,center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,right,right,right,center,center,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,right,right,center,center,center,center,center,right,center,center,right,right,right,right,right,right,center,center,right,center,center,center,center");
	//열에대한 도구설명 활성화/비활성화
	myGrid.enableTooltips("false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false");

	//강조색상
	myGrid.setColumnColor(",,,,,,,,,#ffeb46,#ffeb46,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
	
	myGrid.setNumberFormat("0,000",7);
	myGrid.setNumberFormat("0,000.00",8);
	myGrid.setNumberFormat("0,000.00%",9);
	myGrid.setNumberFormat("0,000",10);
	myGrid.setNumberFormat("0,000",11);
	myGrid.setNumberFormat("0,000.00%",12);
	myGrid.setNumberFormat("0,000",13);
	myGrid.setNumberFormat("0,000",14);
	myGrid.setNumberFormat("0,000",15);
	myGrid.setNumberFormat("0,000",16);
	myGrid.setNumberFormat("0,000",17);
	myGrid.setNumberFormat("0,000.00",18);
	myGrid.setNumberFormat("0,000.00%",19);
	myGrid.setNumberFormat("0,000",20);
	myGrid.setNumberFormat("0,000.00",21);
	myGrid.setNumberFormat("0,000.00",22); 
	myGrid.setNumberFormat("0,000.00",25);
	myGrid.setNumberFormat("0,000.00",26);
	myGrid.setNumberFormat("0,000",28);
	myGrid.setNumberFormat("0,000",29);
	myGrid.setNumberFormat("0,000",30);
	myGrid.setNumberFormat("0,000.00",33);
	myGrid.setNumberFormat("0,000.00",34);
	myGrid.setNumberFormat("0,000",36);
	myGrid.setNumberFormat("0,000",37);
	myGrid.setNumberFormat("0,000",38);
	myGrid.setNumberFormat("0,000.00",41);
	myGrid.setNumberFormat("0,000.00",42);
	myGrid.setNumberFormat("0,000",44);
	myGrid.setNumberFormat("0,000",45);
	myGrid.setNumberFormat("0,000",46);
	myGrid.setNumberFormat("0,000.00",49);
	myGrid.setNumberFormat("0,000.00",50);
	myGrid.setNumberFormat("0,000",52);
	myGrid.setNumberFormat("0,000",53);
	myGrid.setNumberFormat("0,000",54);
	myGrid.setNumberFormat("0,000.00",57);
	myGrid.setNumberFormat("0,000.00",58);
	myGrid.setNumberFormat("0,000",60);
	myGrid.setNumberFormat("0,000",61);
	myGrid.setNumberFormat("0,000",62);
	myGrid.setNumberFormat("0,000.00",65);
	myGrid.setNumberFormat("0,000.00",66);
	myGrid.setNumberFormat("0,000",68);
	myGrid.setNumberFormat("0,000",71);
	myGrid.setNumberFormat("0,000",72);
	myGrid.setNumberFormat("0,000.00",73);
	myGrid.setNumberFormat("0,000",74);
	myGrid.setNumberFormat("0,000.00",75);
	myGrid.setNumberFormat("0,000",76);
	myGrid.setNumberFormat("0,000",79);
	
	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('해당 차량이 없습니다');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	
	//바닥글에 추가줄 추가
	myGrid.attachFooter("편차 부호 반영,#cspan,합계,#cspan,#cspan,#cspan,#cspan,#stat_total,,,#stat_total,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,,#stat_total,,,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,#stat_total,#stat_total,,,,,,#stat_total,,,#stat_total,#stat_total,,#stat_total,,,,,#stat_total,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 부호 반영,#cspan,평균(평균금액 대 평균금액으로 계산),#cspan,#cspan,#cspan,#cspan,#stat_average,#stat_average,{#stat_multi_total_avg}7:10,#stat_average,#stat_average,{#stat_multi_total_avg}7:11,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,{#stat_multi_total_avg}7:20,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,#stat_average,#stat_average,,,#stat_average,#stat_average,,#stat_average,,,#stat_average,#stat_average,{#stat_multi_total_avg}7:71,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);  
	myGrid.attachFooter("편차 부호 반영,#cspan,평균(대비율의 평균),#cspan,#cspan,#cspan,#cspan,,,#stat_average,,,#stat_average,,,,,,,#stat_average,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#stat_average,,,,,,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//그리드 분할
	myGrid.splitAt(7);
		
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true);
    myGrid.enableBlockSelection();
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.parse(data,"json");	   


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

</script>
</html>