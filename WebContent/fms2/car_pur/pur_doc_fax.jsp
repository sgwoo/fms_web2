<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.car_office.*, card.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String pur_pay_dt 	= request.getParameter("pur_pay_dt")==null?"":request.getParameter("pur_pay_dt");
	String num	 	= request.getParameter("num")==null?"":request.getParameter("num");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int table1_h = 350;
	
	//제작증 수신팩스 번호
	UsersBean fax_user_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("제작증수신자"));
	
	String fax_num = fax_user_bean.getI_fax();
	
	if(fax_num.equals("")) fax_num = "0505-920-9876";
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(fax_user_bean.getUser_id());
	if(!cs_bean.getUser_id().equals("") && !cs_bean.getTitle().equals("오후반휴")){
		fax_num = "02-2644-2226"; //이의상반장이 업무대체, 추후 주차장에서 할것임
		if(AddUtil.parseInt(AddUtil.getDate(4)) > 20171231){
			fax_num = "02-6263-6399"; //영남주차장 팩스
			fax_num = "0505-920-9876"; // 20180302 영남주차장 팩스 고장으로 인터넷팩스 이용함.
		}
	}
	
	Hashtable br1 = c_db.getBranch(br_id);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	Hashtable ht 	= a_db.getCommi2(rent_mng_id, rent_l_cd, "2");
	
	
	//카드정보
	CardBean c_bean = CardDb.getCard(pur.getCardno1());
	
	Hashtable ht2 	= CardDb.getCardMngListKMS(pur.getCardno1(), "조성희");
	Hashtable ht3 	= CardDb.getCardMngListKMS(pur.getCardno1(), "허선숙");
	String jcard_no = String.valueOf(ht2.get("CARDNO"));
	String hcard_no = String.valueOf(ht3.get("CARDNO"));
	String card_no ="";
	if(jcard_no.equals(pur.getCardno1())){
		card_no = jcard_no;
	}else if(hcard_no.equals(pur.getCardno1())){
		card_no = hcard_no;
	}
	
	//카드정보2
	CardBean c_bean2 = CardDb.getCard(pur.getCardno2());
	
	Hashtable ht4 	= CardDb.getCardMngListKMS(pur.getCardno2(), "조성희");
	Hashtable ht5 	= CardDb.getCardMngListKMS(pur.getCardno2(), "허선숙");
	String jcard_no2 = String.valueOf(ht4.get("CARDNO"));
	String hcard_no2 = String.valueOf(ht5.get("CARDNO"));
	String card_no2 ="";
	if(jcard_no2.equals(pur.getCardno2())){
		card_no2 = jcard_no2;
	}else if(hcard_no2.equals(pur.getCardno2())){
		card_no2 = hcard_no2;
	}
	
	//카드정보3
	CardBean c_bean3 = CardDb.getCard(pur.getCardno3());
	
	Hashtable ht6 	= CardDb.getCardMngListKMS(pur.getCardno2(), "조성희");
	Hashtable ht7 	= CardDb.getCardMngListKMS(pur.getCardno2(), "허선숙");
	String jcard_no3 = String.valueOf(ht6.get("CARDNO"));
	String hcard_no3 = String.valueOf(ht7.get("CARDNO"));
	String card_no3 ="";
	if(jcard_no3.equals(pur.getCardno3())){
		card_no3 = jcard_no3;
	}else if(hcard_no2.equals(pur.getCardno2())){
		card_no3 = hcard_no3;
	}	
	

	
	//사용자정보
	
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	//차량대금지급처리 팩스관리 공문 테이블//
	String paid_no =  "총무"+AddUtil.getDate(4)+"-"+num;
	String doc_id =  FineDocDb.getFineGovNoNext("특판");
	String sdoc_id = "총무"+doc_id.substring(3);
	int count = 0;
	boolean flag = true;
	boolean flag2 = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){//중복이 없으면 등록
	
	FineDocBn.setDoc_id		(doc_id);
	FineDocBn.setDoc_dt		(AddUtil.getDate());//발신일자
	FineDocBn.setGov_id		(String.valueOf(ht.get("EMP_ID")));
	FineDocBn.setMng_dept		(String.valueOf(ht.get("AGNT_NM")));//참조
	FineDocBn.setReg_id		(user_id);
	FineDocBn.setGov_st		(request.getParameter("lend_cond")==null?"":request.getParameter("lend_cond")); 
	FineDocBn.setMng_nm		(c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM"));//수신1
	FineDocBn.setMng_pos		(String.valueOf(ht.get("CAR_OFF_NM"))); //수신2
	FineDocBn.setH_mng_id		(nm_db.getWorkAuthUser("본사총무팀장"));
	FineDocBn.setB_mng_id		(user_id);
	FineDocBn.setTitle		("자동차대금의 일부 신용카드결제 요청");//제목
	
	flag = FineDocDb.insertFineDoc(FineDocBn);
	
	String car_mng_id = "XXXXXX";
	String rent_s_cd  = request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String firm_nm 	= String.valueOf(pur.getCard_kind1());
	String rpt_no 	= String.valueOf(pur.getRpt_no());
	
	FineDocListBn.setDoc_id			(doc_id);
	FineDocListBn.setCar_mng_id		(car_mng_id);
	FineDocListBn.setSeq_no			(AddUtil.parseInt(num));
	FineDocListBn.setPaid_no		(paid_no);
	FineDocListBn.setRent_mng_id		(rent_mng_id);
	FineDocListBn.setRent_l_cd		(rent_l_cd);
	FineDocListBn.setRent_s_cd		(rent_s_cd);
	FineDocListBn.setFirm_nm		(firm_nm);		//카드사명
	FineDocListBn.setAmt1			(pur.getTrf_amt1());     //차량가격
	FineDocListBn.setVar2			(pur.getCardno1());		//카드번호
	FineDocListBn.setRep_cont		(rpt_no);		//계출번호
	FineDocListBn.setVar1			(c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG"));//차종
	FineDocListBn.setReg_id			(user_id);
	
	flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
	
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<style type="text/css" media="print">    
body {
	-webkit-print-color-adjust: exact; 
	-ms-print-color-adjust: exact; 
	color-adjust: exact;
	/* margin으로 프린트 여백 조정 */
    /* IE */
    margin: 0mm 0mm 0mm 0mm;
    
    /* CHROME */
    -webkit-margin-before: 5mm; /*상단*/
	-webkit-margin-end: 0mm; /*우측*/
	-webkit-margin-after: 5mm; /*하단*/
	-webkit-margin-start: 0mm; /*좌측*/
}
</style>
<script language='javascript'>
<!--
function pagesetPrint(){
	IEPageSetupX.header='';
	IEPageSetupX.footer='';
	IEPageSetupX.leftMargin=12;
	IEPageSetupX.rightMargin=12;
	IEPageSetupX.topMargin=10;
	IEPageSetupX.bottomMargin=10;	
	print();	
}

function onprint() {
	var userAgent=navigator.userAgent.toLowerCase();
	
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		ieprint();
	}
}
	
function ieprint() {
	factory.printing.header = ""; //폐이지상단 인쇄
	factory.printing.footer = ""; //폐이지하단 인쇄
	factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin = 12.0; //좌측여백   
	factory.printing.rightMargin = 10.0; //우측여백
	factory.printing.topMargin = 10.0; //상단여백    
	factory.printing.bottomMargin = 10.0; //하단여백
	factory.printing.Print(true, window); //arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}	
//-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<!--
<OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT>
-->
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			
<input type='hidden' name='andor' value='<%=andor%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>  
<input type='hidden' name='gubun3' value='<%=gubun3%>'>    
<input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" value="<%=rent_l_cd%>">
<input type='hidden' name="num" value="<%=num%>">  
<table width='708' border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td colspan="2" height="50" align="center"></td>
    </tr>
    <tr> 
        <td  height="40" colspan="2" align="center" style="font-size : 15pt;"><b><Strong><font face="바탕">Pick amazoncar! We'll pick you up.</font></Strong></b></td>
    </tr>
    <tr bgcolor="#000000"> 
		<td colspan="2" align='center' height="10" class='line'>
			<table width="100%" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;">
				<tr bgcolor="#FFFFFF"> 
					<td >
						<table width="100%" border="0" cellspacing="0" cellpadding="5">
							<tr> 
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="바탕"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
								<td height="20" style="font-size : 10pt;" ><font face="바탕">Tel:02)392-4243</font></td>
								<td height="20" style="font-size : 10pt;" ><font face="바탕">Fax:02)757-0803</font></td>
							</tr>
							<tr> 
								<td height="20" style="font-size : 10pt;"><font face="바탕">총무팀장 안보국</font></td>
								<td height="20" style="font-size : 10pt;"><font face="바탕">총무팀  조현준</font></td>
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="바탕">tax200@amazoncar.co.kr</font></td>
							</tr>
						</table>
					</td>
				</tr>				
			</table>
		</td>
    </tr>
    <tr>
	    <td colspan="2" style='background-color:000000; height:2'></td>
	</tr>
    <tr> 
		<td colspan="2" height="30" align="center"></td>
    </tr>
    <tr> 
		<td height="100" colspan="2" align='center'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="10%" height="25" style="font-size : 12pt;"><font face="바탕">문서번호</font></td>
					<td width="3%" height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" width="87%" style="font-size : 12pt;"><font face="바탕"><%=sdoc_id%>-<%=num%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">발신일자</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%=AddUtil.getDate()%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%>&nbsp;<%=ht.get("CAR_OFF_NM")%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;조</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%if(ht.get("EMP_ID").equals("030849") || ht.get("EMP_ID").equals("030879")){%><%=ht.get("AGNT_NM")%><%}else{%>담당자님<%}%> (Tel : <%=ht.get("CAR_OFF_TEL")%>, Fax : <%=ht.get("CAR_OFF_FAX")%>)</font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">자동차대금의 일부 신용카드결제 요청</font></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr bgcolor="#999999"> 
		<td colspan=2 align='center' height="2" bgcolor="#333333"><hr width='100%' height='5' color='black'></hr></td>
    </tr>
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width="628" height="20" style="font-size : 12pt;"><p><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 귀 지점의 무궁한 발전을 기원합니다.</font></p>
                    </td>
                </tr>
                <tr>
                   <td height="20" style="font-size : 12pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 아래와 같이 자동차대금 일부를 당사 기업카드로 결제 바랍니다.</font></td>
                </tr>
				<tr>
                    <td height=></td>
                </tr>
                <tr>
                   <td align="center" height="25" style="font-size : 12pt;"><font face="바탕">(&nbsp;&nbsp;아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래&nbsp;&nbsp;)</font></td>
                </tr>
				<tr>
                    <td height=5></td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
                <tr>
					<td class='line'>
						<table width="100%" height="<%if(!c_bean.getCard_edate().equals("")){%>250<%}else{%>100<%}%>" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;">
                            <tr>
                                <td width="" height="" colspan="2" align='center' style="font-size : 12pt;"><font face="굴림">구&nbsp;분</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="굴림">적&nbsp;요</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림">비&nbsp;고</font></td>
                            </tr>
                            <tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">계출번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
                            <tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">차종</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<%if(!c_bean.getCard_edate().equals("")){%>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="굴림">신용<br>카드<br>결제</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드사명</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getCard_kind1()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">신용카드<br>소유자</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림">(주)아마존카</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
                          </tr>
						  <tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=pur.getCardno1()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%if(card_no.equals(pur.getCardno1())){%>기명식카드<%}%><%if(!jcard_no.equals("null")){%>( 조성희 )<%}else if(!hcard_no.equals("null")){%>( 허선숙 )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">유효기간<br>(월/년)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=AddUtil.ChangeDate7(c_bean.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드<br>결제금액</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt1())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림">일시불</font></td>
                            </tr>
                            <%}else{ %>	
                            <%	if(pur.getTrf_st1().equals("4")){%>
                            <tr>
                                <td width="10%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">대출</font></td>
								<td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림"><%=pur.getCard_kind1()%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt1())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
                            <%	}%>    
                            <%}%>
						</table>
					</td>
                </tr>
 				<%if(!c_bean2.getCard_edate().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="250" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">계출번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">차종</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="굴림">신용<br>카드<br>결제</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드사명</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getCard_kind2()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">신용카드<br>소유자</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림">(주)아마존카</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=pur.getCardno2()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%if(card_no2.equals(pur.getCardno2())){%>기명식카드<%}%><%if(!jcard_no2.equals("null")){%>( 조성희 )<%}else if(!hcard_no2.equals("null")){%>( 허선숙 )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">유효기간<br>(월/년)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=AddUtil.ChangeDate7(c_bean2.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드<br>결제금액</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt2())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림">일시불</font></td>
                            </tr>
						</table>
					</td>
                </tr>
				
				<%}%>
				
				<%if(!c_bean3.getCard_edate().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="250" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">계출번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="" height="" colspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">차종</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="5" style="font-size : 12pt; text-align: center;"><font face="굴림">신용<br>카드<br>결제</font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드사명</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=pur.getCard_kind3()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">신용카드<br>소유자</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림">(주)아마존카</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=pur.getCardno3()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%if(card_no3.equals(pur.getCardno3())){%>기명식카드<%}%><%if(!jcard_no3.equals("null")){%>( 조성희 )<%}else if(!hcard_no3.equals("null")){%>( 허선숙 )<%}%></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">유효기간<br>(월/년)</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=AddUtil.ChangeDate7(c_bean3.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">카드<br>결제금액</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt3())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림">일시불</font></td>
                            </tr>
						</table>
					</td>
                </tr>
				
				<%}%>

				<%if(c_bean2.getCard_edate().equals("") && !pur.getCard_kind2().equals("")&&pur.getTrf_st2().equals("1")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
                                <td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st2().equals("1")){%>현금<%}else if(pur.getTrf_st2().equals("5")){%>포인트<%}%></font></td>
								<td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st2().equals("1")){%>계약금<%}else if(pur.getTrf_st2().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>블루<%}else{%>레드<%}%>멤버스카드<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt2())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st2().equals("1")){%>계좌이체<%}else if(pur.getTrf_st2().equals("2")){%>선불카드<%}else if(pur.getTrf_st2().equals("3")){%>후부카드<%}else if(pur.getTrf_st2().equals("4")){%>대출<%}else if(pur.getTrf_st2().equals("5")){%><%}else if(pur.getTrf_st2().equals("6")){%>구매보조금<%}else if(pur.getTrf_st2().equals("7")){%>카드할부<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>		
				
				<%if(c_bean3.getCard_edate().equals("") && !pur.getCard_kind3().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st3().equals("1")){%>현금<%}else if(pur.getTrf_st3().equals("5")){%>포인트<%}%></font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st3().equals("1")){%>계약금<%}else if(pur.getTrf_st3().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>블루<%}else{%>레드<%}%>멤버스카드<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt3())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st3().equals("1")){%>계좌이체<%}else if(pur.getTrf_st3().equals("2")){%>선불카드<%}else if(pur.getTrf_st3().equals("3")){%>후부카드<%}else if(pur.getTrf_st3().equals("4")){%>대출<%}else if(pur.getTrf_st3().equals("5")){%><%}else if(pur.getTrf_st3().equals("6")){%>구매보조금<%}else if(pur.getTrf_st3().equals("7")){%>카드할부<%}%></font></td>
							</tr>
							
						</table>
					</td>
                </tr>
				<%}%>		
				
				<%if(!pur.getCard_kind4().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;"><%if(pur.getTrf_st4().equals("1")){%>현금<%}else if(pur.getTrf_st4().equals("5")){%>포인트<%}%></font></td>
                                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st4().equals("1")){%>계약금<%}else if(pur.getTrf_st4().equals("5")){%><%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0001")){%>블루<%}else{%>레드<%}%>멤버스카드<%}%></font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt4())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st4().equals("1")){%>계좌이체<%}else if(pur.getTrf_st4().equals("2")){%>선불카드<%}else if(pur.getTrf_st4().equals("3")){%>후불카드<%}else if(pur.getTrf_st4().equals("4")){%>대출<%}else if(pur.getTrf_st4().equals("5")){%><%}else if(pur.getTrf_st4().equals("6")){%>구매보조금<%}else if(pur.getTrf_st4().equals("7")){%>카드할부<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>	
				<%if(!pur.getCard_kind5().equals("")){%>
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="10%" height="" style="font-size : 12pt; text-align: center;">현금</font></td>
                <td width="15%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">임시운행보험료</font></td>
                <td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><b><%=AddUtil.parseDecimal(pur.getTrf_amt5())%></b> 원</font></td>
                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%if(pur.getTrf_st5().equals("1")){%>계좌이체<%}else if(pur.getTrf_st5().equals("2")){%>선불카드<%}else if(pur.getTrf_st5().equals("3")){%>후불카드<%}%></font></td>
							</tr>
						</table>
					</td>
                </tr>
				<%}%>					
				<tr>
					<td class='line'>			
						<table width="100%" height="" border=1 cellspacing=0 cellpadding=0 style="border-collapse: collapse;" >
							<tr>
								<td width="25%" height="" style="font-size : 12pt; text-align: center;"><font face="굴림">결제일자</font></td>
								<td width="50%" style="font-size : 12pt; text-align: center; font-weight:bold;"><font face="굴림"><%=AddUtil.getDate()%></font></td>
								<td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"></font></td>
							</tr>
							<tr>
                                <td width="25%" rowspan="2" style="font-size : 12pt; text-align: center;"><font face="굴림">담당자</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%=user_bean.getUser_nm()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="굴림"><%=user_bean.getHot_tel()%></font></td>
                            </tr>
						</table>
					</td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
				<%if(!ht.get("CAR_OFF_NM").equals("법인판촉팀")){%>
				<tr>
                    <td height=5></td>
                </tr>
                <tr>
                   	<td height="25" style="font-size : 14pt;">
                   		<font face="바탕">
                   			※ 카드승인후 조건변경 완료가 끝나면 <b>[제작증을 FAX.<%=fax_num%>]</b><br/>
                   			&nbsp;&nbsp;&nbsp;로 11:30분까지 꼭 보내주시기 바랍니다.<br/>
                   			&nbsp;&nbsp;&nbsp;<b>(※ 등록업무로 인하여 시간을 꼭 지켜주시기 바랍니다.)</b>
                   		</font>
                   	</td>
                </tr>
				<%}%>
                <!-- <tr>
                   <td height="25" style="font-size : 10pt;"><font face="바탕">※ 수입인지(원본)는 우편으로 보내주시거나 인지대금(현금)을 아래 계좌로 입금하여 주시길 바랍니다. <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>(계좌 : 신한은행 140-004-023863)</font></td>
                </tr> -->
                <tr>
                	<td height="25" style="font-size : 10pt;">
                		<font face="바탕" style="letter-spacing: -1.2px;">
                			※ 수입인지 원본은 반드시 본사 아래 주소로 우편발송해주시고, 부득이 인지대금(￦3,000)을 아래 계좌송금 할 경우<br>
                   			 대리점 명으로 입금 후 별도 연락 바랍니다.(T.02-6263-6370)<br>                   			
                   		</font>
                   		<br>
                   		<font face="바탕">
							주소 : 서울 영등포구 의사당대로8 태흥빌딩 8층 아마존카 총무팀 담당자앞<br>
							계좌 : 신한은행 140-004-023863							
						</font>
					</td>
                </tr>
				<!-- <tr>
                    <td height=5></td>
                </tr> -->
				<!--
				<tr>
                   <td height="25" style="font-size : 11pt;"><font face="바탕">※ 별도 연락시에 제작증을 <b>FAX. 02-757-0803, 02-782-0826</b> 으로 보내주시기 바랍니다. </font></td>
                </tr>
				-->
			</table>
        </td>
    </tr>
</table>
<table width='708' height="" border="0" cellpadding="0" cellspacing="0">

<%if(pur.getCard_kind2().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
<%if(pur.getCard_kind3().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
<%if(pur.getCard_kind4().equals("")){%>	
	<tr>
		<td height="" class="h"></td>
	</tr>
<%}%>
	<!-- <tr> 
		<td width="708" colspan="2"><font face="바탕">&nbsp;</font></td>
	</tr> -->
	<tr align="center"> 
		<td height="" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사&nbsp;아마존카&nbsp;&nbsp;&nbsp;&nbsp;대표이사&nbsp;&nbsp;&nbsp;&nbsp;조&nbsp;&nbsp;성&nbsp;&nbsp;희</b><img src=/acar/images/stamp_sq.jpg align="middle" width="100" height="100"></font></td>
	</tr>
</table>
</form>
</body>
</html>
