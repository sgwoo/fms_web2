<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.car_office.*, card.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String pur_pay_dt 	= request.getParameter("pur_pay_dt")==null?"":request.getParameter("pur_pay_dt");
	String num	 	= request.getParameter("num")==null?"":request.getParameter("num");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int table1_h = 350;
	Vector fines = FineDocDb.getPur_doc_review_select(doc_id);
	int fine_size = fines.size();
	for(int i = 0 ; i < fine_size ; i++){
    				
	Hashtable ht6 = (Hashtable)fines.elementAt(i);
		
	rent_l_cd = (String)ht6.get("RENT_L_CD");
	rent_mng_id = (String)ht6.get("RENT_MNG_ID");
	num = (String)ht6.get("SEQ_NO");
	
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
	

	
	//사용자정보
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=15;
		IEPageSetupX.rightMargin=15;
		IEPageSetupX.topMargin=30;
		IEPageSetupX.bottomMargin=20;	
		print();
	
	}
	
function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 12.0; //좌측여백   
factory.printing.rightMargin = 12.0; //우측여백
factory.printing.topMargin = 20.0; //상단여백    
factory.printing.bottomMargin = 20.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}		
//-->
</script>
</head>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>

<body leftmargin="10" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
<!--
<OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT>
-->
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="num" 		value="<%=num%>">  
<table width='708'  border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr> 
		<td colspan="2" height="50" align="center"></td>
    </tr>
    <tr> 
        <td  height="40" colspan="2" align="center" style="font-size : 15pt;"><b><Strong><font face="바탕">Pick amazoncar! We'll pick you up.</font></Strong></b></td>
    </tr>
    <tr bgcolor="#000000"> 
		<td colspan="2" align='center' height="10" class='line'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#FFFFFF"> 
					<td >
						<table width="100%" border="0" cellspacing="0" cellpadding="5">
							<tr> 
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="바탕">150-874
								서울시 영등포구 여의도동 17-3 (까뮤이앤씨빌딩802호)</font></td>
								<td height="20" style="font-size : 10pt;" ><font face="바탕">Tel:02)392-4243</font></td>
								<td height="20" style="font-size : 10pt;" ><font face="바탕">Fax:02)757-0803</font></td>
							</tr>
							<tr> 
								<td height="20" style="font-size : 10pt;"><font face="바탕">총무팀장 안보국</font></td>
								<td height="20" style="font-size : 10pt;"><font face="바탕">총무팀 과장 김태우</font></td>
								<td height="20" colspan="2" style="font-size : 10pt;"><font face="바탕">rlaxodn95@ymail.com</font></td>
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
		<td colspan="2" height="50" align="center"></td>
    </tr>
    <tr> 
		<td height="100" colspan="2" align='center'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td width="10%" height="25" style="font-size : 12pt;"><font face="바탕">문서번호</font></td>
					<td width="3%" height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" width="87%" style="font-size : 12pt;"><font face="바탕"><%=ht6.get("PAID_NO")%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">발신일자</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%=AddUtil.getDate3(String.valueOf(ht6.get("DOC_DT")))%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%=ht6.get("MNG_NM")%>&nbsp;<%=ht6.get("MNG_POS")%></font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 조</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕"><%if(ht6.get("GOV_ID").equals("030849") || ht6.get("GOV_ID").equals("030879")){%><%=ht6.get("MNG_DEPT")%><%}else{%>담당자님<%}%>(Tel : <%=ht.get("CAR_OFF_TEL")%>, Fax : <%=ht.get("CAR_OFF_FAX")%>)</font></td>
				</tr>
				<tr> 
					<td height="25" style="font-size : 12pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 목</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">:</font></td>
					<td height="25" style="font-size : 12pt;"><font face="바탕">자동차대금의 일부 신용카드결재 요청</font></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr bgcolor="#999999"> 
		<td colspan=2 align='center' height="2" bgcolor="#333333"><hr width='100%' height='5' color='black'></hr></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" align='center'></td>
    </tr>  
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width="628" height="25" style="font-size : 12pt;"><p><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 귀 지점의 무궁한 발전을 기원합니다.</font></p>
                    </td>
                </tr>
				<tr>
                    <td height=10></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 12pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 아래와 같이 자동차대금 일부를 당사 기업카드로 결재 바랍니다.</font></td>
                </tr>
				<tr>
                    <td height=10></td>
                </tr>
                <tr>
                   <td align="center" height="25" style="font-size : 12pt;"><font face="바탕">(&nbsp;&nbsp;아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래&nbsp;&nbsp;)</font></td>
                </tr>
				<tr>
                    <td height=10></td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
                <tr>
					<td class='line'>
						<table width=100% height="200" border=0 cellspacing=1 cellpadding=0 >
                            <tr>
                                <td width="25%" height="30" colspan="2" align='center' style="font-size : 12pt;"><font face="바탕">구&nbsp;분</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="바탕">적&nbsp;요</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕">비&nbsp;고</font></td>
                            </tr>
                            <tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">카드사명</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=pur.getCard_kind1()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
                            <tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">신용카드소유자</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕">(주)아마존카</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
							<tr>
                                <td width="30%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">카드번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="바탕"><b><%=pur.getCardno1()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"><%if(card_no.equals(pur.getCardno1())){%>기명식카드<%}%><%if(!jcard_no.equals("null")){%>( 조성희 )<%}else if(!hcard_no.equals("null")){%>( 허선숙 )<%}%></font></td>
							</tr>
							<tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">유효기간(월/년)</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=AddUtil.ChangeDate7(c_bean.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="4" style="font-size : 12pt; text-align: center;"><font face="바탕">대금<br>결재</font></td>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">계출번호</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">차종</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">금액</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="바탕"><b><%=AddUtil.parseDecimal(pur.getTrf_amt1())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕">일시불</font></td>
                            </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">결재일자</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=AddUtil.getDate3(String.valueOf(ht6.get("DOC_DT")))%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                            </tr>
						</table>
					</td>
                </tr>
							<%if(!c_bean2.getCard_edate().equals("")){%>
				<tr>
					<td height="10" class=""></td>
				</tr>
				<tr>
					<td class='line'>			
						<table width=100% height="200" border=0 cellspacing=1 cellpadding=0 >
							<tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">카드사명</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=pur.getCard_kind2()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
                            <tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">신용카드소유자</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕">(주)아마존카</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
							<tr>
                                <td width="30%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">카드번호</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="바탕"><b><%=pur.getCardno2()%></b></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"><%if(card_no2.equals(pur.getCardno2())){%>기명식카드<%}%><%if(!jcard_no2.equals("null")){%>( 조성희 )<%}else if(!hcard_no2.equals("null")){%>( 허선숙 )<%}%></font></td>
							</tr>
							<tr>
                                <td width="25%" height="30" colspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">유효기간(월/년)</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=AddUtil.ChangeDate7(c_bean2.getCard_edate())%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
							</tr>
							<tr>
                                <td width="10%" rowspan="4" style="font-size : 12pt; text-align: center;"><font face="바탕">대금<br>결재</font></td>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">계출번호</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=pur.getRpt_no()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">차종</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                          </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">금액</font></td>
                                <td width="50%" style="font-size : 12pt; text-align: center;"><font face="바탕"><b><%=AddUtil.parseDecimal(pur.getTrf_amt2())%></b> 원</font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕">일시불</font></td>
                            </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">결재일자</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=AddUtil.getDate3(String.valueOf(ht6.get("DOC_DT")))%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                            </tr>
						</table>
					</td>
                </tr>
							<%}%>
				<tr>
					<td height="10" class=""></td>
				</tr>
				<tr>
					<td class='line'>			
						<table width=100% height="50" border=0 cellspacing=1 cellpadding=0 >
							<tr>
                                <td width="10%" rowspan="2" style="font-size : 12pt; text-align: center;"><font face="바탕">담당자</font></td>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">성명</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=user_bean.getUser_nm()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                            </tr>
							<tr>
                                <td width="15%" height="30" style="font-size : 12pt; text-align: center;"><font face="바탕">연락처</font></td>
                                <td width="50%" style="font-size : 10pt; text-align: center;"><font face="바탕"><%=user_bean.getHot_tel()%></font></td>
                                <td width="25%" style="font-size : 12pt; text-align: center;"><font face="바탕"></font></td>
                            </tr>
						</table>
					</td>
                </tr>
                <tr>
				    <td colspan="2" style='background-color:000000; height:1'></td>
				</tr>
			</table>
        </td>
    </tr>
<%if(c_bean2.getCard_edate().equals("")){%>		
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<tr>
		<td height="100" class="h"></td>
	</tr>
	<%}%>
	<tr> 
		<td width="708" colspan="2"><font face="바탕">&nbsp;</font></td>
	</tr>
	<tr align="center"> 
		<td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사&nbsp;아마존카&nbsp;&nbsp;&nbsp;&nbsp;대표이사&nbsp;&nbsp;&nbsp;&nbsp;조&nbsp;&nbsp;성&nbsp;&nbsp;희</b><img src=/acar/images/stamp_sq.jpg align="middle"></font></td>
	</tr>
</table>
<%}%>
</form>
</body>
</html>
