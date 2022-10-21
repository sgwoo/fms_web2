<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.con_ins.*, cust.rent.*, acar.user_mng.*, tax.*"%>
<jsp:useBean id="p_db" scope="page" class="cust.pay.PayDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_site = request.getParameter("s_site")==null?"":request.getParameter("s_site");
	String s_car_no = request.getParameter("s_car_no")==null?"":request.getParameter("s_car_no");
	String s_car_comp_id = request.getParameter("s_car_comp_id")==null?"":request.getParameter("s_car_comp_id");
	String s_car_cd = request.getParameter("s_car_cd")==null?"":request.getParameter("s_car_cd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String tax_no = request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	int count = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Hashtable item = p_db.getDocCase(item_id);
	
	Vector items1 = p_db.getTaxItemList(item_id);
	int item_size1 = items1.size();
	
	Vector items2 = p_db.getTaxItemKiList(item_id);
	int item_size2 = items2.size();
	
	long item_s_amt1 = 0;
	long item_v_amt1 = 0;
	long item_s_amt2 = 0;
	
	//출력 체크
	count = p_db.insertPrint(member_id, request.getRemoteAddr(), "2", "", item_id);
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	String branch = t_bean.getBranch_g();
	if(branch.equals("")) branch = "S1";
	//공급자
	Hashtable br            = c_db.getBranch(branch);
	
	//업무대여일때
	UserMngDatabase umd = UserMngDatabase.getInstance();
	if(t_bean.getGubun().equals("13")){
		user_bean = umd.getUsersBean(t_bean.getClient_id().trim());
	}
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function pagesetPrint(){
		var userAgent = navigator.userAgent.toLowerCase();
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
			IE_Print();
		}
	}
	

	function IE_Print(){
		factory1.printing.header='';
		factory1.printing.footer='';
		factory1.printing.leftMargin=20;
		factory1.printing.rightMargin=20;
		factory1.printing.topMargin=20;
		factory1.printing.bottomMargin=20;
		factory1.printing.Print(true, window);
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' method='post' action='tax_frame.jsp' target=''>
  <table border='0' cellspacing='0' cellpadding='0' width='600'>
    <tr> 
      <td colspan="2"> 
        <table width='600' cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="2"> 
              <table width="600" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td style="border: #000000 2px solid" align="center" valign="middle"> 
                    <table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
                      <tr> 
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="210">&nbsp;</td>
                        <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">거 
                          래 명 세 서</font></td>
                        <td width="210">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td align="center" height="25" valign="bottom"><!--(고 객 용)--></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="50%" height="40">&nbsp;</td>
                      <td width="5%">&nbsp;</td>
                      <td rowspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공<br>
                                <br>
                        급<br>
                        <br>
                        자</td>
                            <td height="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">등록번호</td>
                            <td height="30" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">상호</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont">주식회사아마존카 </span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">성명</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_OWN_NM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">사업장<br>주소</td>
                            <td height="30" colspan="3" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ADDR")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">업태</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("BR_STA")%></span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">종목</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ITEM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">대표전화</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("TEL")%></span>&nbsp;</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">팩스</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("FAX")%></span>&nbsp;</td>
                          </tr>
                      </table></td>
                    </tr>
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="22" width="25%">관&nbsp;리&nbsp;번&nbsp;호</td>
                                    <td height="22" width="5%" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=item.get("ITEM_ID")%></td>
                                    <td height="22" width="20%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">작&nbsp;&nbsp;&nbsp;성&nbsp;&nbsp;&nbsp;일</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=AddUtil.getDate3(String.valueOf(item.get("ITEM_DT")))%></td>
                                    <td height="22">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">상호&nbsp;(성명)</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;
									<%if(t_bean.getGubun().equals("13")){%>
									<%=user_bean.getUser_nm()%>
									<%}else{%>
									<%=item.get("FIRM_NM")%>&nbsp;<%=item.get("R_SITE2")%>
									<%}%>
									</td>
                                  </tr>
                                  <tr> 
                                    <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                                  </tr>
                                  <tr> 
                                    <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" width="12%" style="border-bottom: #000000 1px solid">일금</td>
                                    <td height="22" style="border-bottom: #000000 1px solid" align="right" width="38%">&nbsp;<%=item.get("ITEM_HAP_STR")%></td>
                                    <td height="22" align="right" style="border-bottom: #000000 1px solid">정</td>
                                  </tr>
                                </table>
                              </td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="20" align="right">(￦<%=Util.parseDecimal(String.valueOf(item.get("ITEM_HAP_NUM")))%>)</td>
                        <td height="30" rowspan="2">&nbsp;</td>
                        <td height="30" align="right" rowspan="2">작성자 : &nbsp;&nbsp;<%=item.get("ITEM_MAN")%></td>
                      </tr>
                      <tr> 
                        <td height="15" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="center" bgcolor="#CCCCCC"> 
                              <td rowspan="2" width="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                              <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                              <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                              <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                              <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구(거래)기준일</td>
                              <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                              <td rowspan="2" width="55" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                              <td rowspan="2" width="65" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
                            </tr>
                            <tr> 
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                            </tr>
                            <%		for(int i = 0 ; i < item_size1 ; i++){
										Hashtable item1 = (Hashtable)items1.elementAt(i);%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_SEQ")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">
					  			<%if(!String.valueOf(item1.get("REG_DT")).equals("") && AddUtil.parseInt(AddUtil.replace(String.valueOf(item1.get("REG_DT")).substring(0,10),"-","")) >= 20100929 && String.valueOf(item1.get("GUBUN")).equals("1") && !String.valueOf(item1.get("TM")).equals("") && !String.valueOf(item.get("TM_PRINT_YN")).equals("N")){%>
						        <%=String.valueOf(item1.get("TM"))%>회차
						        <%}%>							  
							    <%=item1.get("ITEM_G")%>
							  </font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_CAR_NO")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;<%=item1.get("ITEM_CAR_NM")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT1")))%>&nbsp;</font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT2")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_SUPPLY")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_VALUE")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><font size="1"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item1.get("ITEM_SUPPLY")))+AddUtil.parseInt(String.valueOf(item1.get("ITEM_VALUE"))))%>&nbsp;</font></td>
                            </tr>
                            <%			item_s_amt1 = item_s_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_SUPPLY")));
										item_v_amt1 = item_v_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_VALUE")));
									}%>
                            <%		for(int i = 0 ; i < 16-item_size1 ; i++){%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                            </tr>
                            <%	}%>
                            <tr> 
                              <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계</b></font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_v_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1+item_v_amt1)%>&nbsp;</font></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="3"><font size="1">※ 일할계산(대여료) : (월대여료ⅹ대여일수)÷30일</font></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><font size="3"><b>※ 기타</b></font></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="center" bgcolor="#CCCCCC"> 
                              <td height="25" width="110" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">청구구분</td>
                              <td height="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">적요</td>
                              <td height="25" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">금액</td>
                              <td height="25" width="130" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">비고</td>
                            </tr>
                            <%		for(int i = 0 ; i < item_size2 ; i++){
										Hashtable item2 = (Hashtable)items2.elementAt(i);%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item2.get("ITEM_KI_G")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;<%=item2.get("ITEM_KI_APP")%></font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(item2.get("ITEM_KI_PR")))%>&nbsp;</font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><font size="1">&nbsp;<%=item2.get("ITEM_KI_BIGO")%></font></td>
                            </tr>
                            <%			item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(item2.get("ITEM_KI_PR")));
									}%>
                            <%		for(int i = 0 ; i < 5-item_size2 ; i++){%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                            </tr>
                            <%	}%>
                            <tr> 
                              <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>합계</b></font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt2)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                        <td height="20">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
    </tr>
  </table>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 575px; WIDTH: 68px; POSITION: absolute; TOP: 120px; HEIGHT: 68px"><IMG src="../../images/cust/3c7kR522I6Sqs_70.gif"></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>