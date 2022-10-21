<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.con_ins.*, acar.accid.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="p_db" scope="page" class="cust.pay.PayDatabase"/>
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
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	int seq_no = request.getParameter("seq_no")==null?0:Util.parseInt(request.getParameter("seq_no"));//사고관리일련번호
	int count = 0;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	Hashtable item = p_db.getDocCase(item_id);
	
	UsersBean user_bean = new UsersBean();
	
	if(!String.valueOf(item.get("ITEM_MAN")).equals("")){
		user_bean = umd.getUserNmBean(String.valueOf(item.get("ITEM_MAN")));
	}
	
	Vector items1 = p_db.getTaxItemList(item_id);
	int item_size1 = items1.size();
	
	Vector items2 = p_db.getTaxItemKiList(item_id);
	int item_size2 = items2.size();
	
	long item_s_amt1 = 0;
	long item_v_amt1 = 0;
	long item_s_amt2 = 0;
	
	//출력 체크
	count = p_db.insertPrint(member_id, request.getRemoteAddr(), "2", "", item_id);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(car_mng_id, accid_id);
	
	//계약조회
	Hashtable cont = as_db.getRentCase(a_bean.getRent_mng_id(), a_bean.getRent_l_cd());
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(car_mng_id, accid_id , seq_no);
	
	//System.out.println("보험:"+ma_bean.getIns_com());
	
	//청구서발행 조회
	TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(car_mng_id, accid_id);
	
	
	String i_start_dt = ma_bean.getIns_use_st();
    	String i_start_h 	= "00";
    	String i_start_s 	= "00";
    	String get_start_dt = ma_bean.getIns_use_st();
    	if(get_start_dt.length() == 12){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    		i_start_s	= get_start_dt.substring(10,12);
    	}
	String i_end_dt = ma_bean.getIns_use_et();
    	String i_end_h 	= "00";
    	String i_end_s 	= "00";
    	String get_end_dt = ma_bean.getIns_use_et();
    	if(get_end_dt.length() == 12){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    		i_end_s		= get_end_dt.substring(10,12);
    	}
%>
<html>
<head>
<title>거래명세서</title>
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
<%if(mode.equals("accid_doc")){%>
<body>
<%}else{%>
<body leftmargin="15" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> --> 
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%}%>

<form name='form1' method='post' action='tax_frame.jsp' target=''>
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="accid_id" value="<%=accid_id%>">
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
                        <td align="center" height="25" valign="bottom">(청 구 서)</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="50%" height="15">&nbsp;</td>
                              <td width="5%">&nbsp;</td>
                              <td rowspan="2"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">공<br>
                                      <br>
                                      급<br>
                                      <br>
                                      자</font></td>
                                    <td height="25" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">등록번호</font></td>
                                    <td height="25" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">128-81-47957</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">상호</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">(주)아마존카</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">성명</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">조성희</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">사업장주소</font></td>
                                    <td height="25" colspan="3" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">서울 
                                      영등포구 여의도동 17-3</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">업태</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">서비스</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">종목</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">대여사업</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">대표전화</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">02)392-4243</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">팩스</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">02-757-0803</font></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="22" width="25%">관&nbsp;리&nbsp;번&nbsp;호</td>
                                    <td height="22" width="5%" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=item.get("ITEM_ID")%></td>
                                    <td height="22" width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">작&nbsp;&nbsp;&nbsp;성&nbsp;&nbsp;&nbsp;일</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=AddUtil.getDate3(String.valueOf(item.get("ITEM_DT")))%></td>
                                    <td height="22">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">수&nbsp;&nbsp;&nbsp;신&nbsp;&nbsp;&nbsp;처</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;<%=cont.get("FIRM_NM")%><!--<%=ma_bean.getIns_com()%>&nbsp;<%=ma_bean.getIns_nm()%>--></td>
                                  </tr>
                                  <tr> 
                                    <td height="22">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;조</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;<%=ma_bean.getIns_com()%>&nbsp;<%=ma_bean.getIns_nm()%></td>
                                  </tr>
                                  <tr> 
                                    <td height="22" colspan="5"><b>아래와 같이 계산합니다.</b></td>
                                  </tr>
                                  <tr> 
                                    <td height="22">합&nbsp;계&nbsp;금&nbsp;액</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" width="10%" style="border-bottom: #000000 1px solid">일금</td>
                                    <td height="22" style="border-bottom: #000000 1px solid" align="right" width="55%">&nbsp;<%=item.get("ITEM_HAP_STR")%></td>
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
                        <td height="30" align="right" rowspan="2">작성자 : &nbsp;&nbsp;<%=item.get("ITEM_MAN")%> (<%=user_bean.getUser_m_tel()%>)</td>
                      </tr>
                      <tr> 
                        <td height="15" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="center" bgcolor="#CCCCCC"> 
                              <td rowspan="2" width="30" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">연번</td>
                              <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">거래구분</td>
                              <td rowspan="2" width="75" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">차량번호</td>
                              <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">차명</td>
                              <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">사고대차기간</td>
                              <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">공급가액</td>
                              <td rowspan="2" width="55" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">세액</td>
                              <td rowspan="2" width="65" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">합계</td>
                            </tr>
                            <tr> 
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~부터</td>
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~까지</td>
                            </tr>
                            <%		for(int i = 0 ; i < 1 ; i++){
										Hashtable item1 = (Hashtable)items1.elementAt(i);%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_SEQ")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_G")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_CAR_NO")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;<%=item1.get("ITEM_CAR_NM")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT1")))%>&nbsp;<br><%=i_start_h%>시<%=i_start_s%>분</font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=AddUtil.ChangeDate2(String.valueOf(item1.get("ITEM_DT2")))%>&nbsp;<br><%=i_end_h%>시<%=i_end_s%>분</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_SUPPLY")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=Util.parseDecimal(String.valueOf(item1.get("ITEM_VALUE")))%>&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><font size="1"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item1.get("ITEM_SUPPLY")))+AddUtil.parseInt(String.valueOf(item1.get("ITEM_VALUE"))))%>&nbsp;</font></td>
                            </tr>
                            <%			item_s_amt1 = item_s_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_SUPPLY")));
										item_v_amt1 = item_v_amt1  + Long.parseLong(String.valueOf(item1.get("ITEM_VALUE")));
									}%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
                              <td colspan="7" height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">
							  	<font size="1">
									<%if(ma_bean.getUse_hour().equals("")){%>
										<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>원(일)*<%=ma_bean.getIns_use_day()%>일*
									<%}else{%>
										((<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>원(일)*<%=ma_bean.getIns_use_day()%>일)+(<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>원(일)/24*<%=ma_bean.getUse_hour()%>시간))*
									<%}%>
									
									<%if(ti.getGubun().equals("11")){%>
										과실<%=Math.abs(a_bean.getOur_fault_per()-100)%>%, 
										대차:<%=ma_bean.getIns_car_no()%>
									<%}%>
									, 
									접수번호:&nbsp;<%=ma_bean.getIns_num()%>
								</font>
							  </td>
                              <!--<td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
							  -->
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><font size="1">&nbsp;</font></td>
                            </tr>									
                            <%		for(int i = 0 ; i < 20-item_size1 ; i++){%>
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
                        <td colspan="2"><font size="1">※ 산출근거 : 공문서 참조</font></td>
						<td align="right">(주)아마존카</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
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
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 555px; WIDTH: 68px; POSITION: absolute; TOP: 140px; HEIGHT: 68px"><IMG src="/images/cust/3c7kR522I6Sqs_70.gif"></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>