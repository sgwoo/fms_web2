<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.rent.*, acar.client.*, tax.*, acar.accid.*, acar.car_service.*, acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" 	scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cr_bean" 	scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="p_db" scope="page" class="cust.pay.PayDatabase"/>
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
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//���������ȣ
	
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
	int count = 0;
	
	AccidDatabase as_db 		= AccidDatabase.getInstance();
	UserMngDatabase umd 		= UserMngDatabase.getInstance();
	AddCarServDatabase a_csd 	= AddCarServDatabase.getInstance();
	
	//�ŷ����� ��ȸ
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
	
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
	
	//��� üũ
	count = p_db.insertPrint(member_id, request.getRemoteAddr(), "2", "", item_id);
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(car_mng_id, accid_id);
	
	//����/����(��å��)
	ServiceBean s_bean = a_csd.getService(car_mng_id, accid_id, serv_id);
	
	//û�������� ��ȸ
	TaxItemListBean ti = IssueDb.getTaxItemListServM(car_mng_id, serv_id, s_bean.getCust_amt());
	
	//�ŷ�ó����
	ClientBean client       = al_db.getClient(ti_bean.getClient_id().trim());
	//�ŷ�ó��������
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	
	String i_firm_nm 	= client.getFirm_nm();
	if(!ti_bean.getSeq().equals("")){
		i_firm_nm 		= site.getR_site();
	}
%>
<html>
<head>
<title>�ŷ�����</title>
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
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="accid_id" value="<%=accid_id%>">
  <input type="hidden" name="serv_id" value="<%=serv_id%>">  
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
                        <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">�� 
                          �� �� �� ��</font></td>
                        <td width="210">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td align="center" height="25" valign="bottom">(û �� ��)</td>
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
                                    <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">��<br>
                                      <br>
                                      ��<br>
                                      <br>
                                      ��</font></td>
                                    <td height="25" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">��Ϲ�ȣ</font></td>
                                    <td height="25" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">128-81-47957</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">��ȣ</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">(��)�Ƹ���ī</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">����</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">������</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">������ּ�</font></td>
                                    <td height="25" colspan="3" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">���� 
                                      �������� ���ǵ��� 17-3</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">����</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">����</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">����</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">�뿩���</font></td>
                                  </tr>
                                  <tr> 
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">��ǥ��ȭ</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">02)392-4243</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">�ѽ�</font></td>
                                    <td height="25" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><font size="1">02-757-0803</font></td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="22" width="25%">��&nbsp;��&nbsp;��&nbsp;ȣ</td>
                                    <td height="22" width="5%" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=item.get("ITEM_ID")%></td>
                                    <td height="22" width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="2">&nbsp;<%=AddUtil.getDate3(String.valueOf(item.get("ITEM_DT")))%></td>
                                    <td height="22">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="22">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;ó</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" colspan="3">&nbsp;<%=i_firm_nm%></td>
                                  </tr>
                                  <tr> 
                                    <td height="22" colspan="5"><b>�Ʒ��� ���� ����մϴ�.</b></td>
                                  </tr>
                                  <tr> 
                                    <td height="22">��&nbsp;��&nbsp;��&nbsp;��</td>
                                    <td height="22" align="center">:</td>
                                    <td height="22" width="10%" style="border-bottom: #000000 1px solid">�ϱ�</td>
                                    <td height="22" style="border-bottom: #000000 1px solid" align="right" width="55%">&nbsp;<%=item.get("ITEM_HAP_STR")%></td>
                                    <td height="22" align="right" style="border-bottom: #000000 1px solid">��</td>
                                  </tr>
                                </table>
                              </td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td height="20" align="right">(��<%=Util.parseDecimal(String.valueOf(item.get("ITEM_HAP_NUM")))%>)</td>
                        <td height="30" rowspan="2">&nbsp;</td>
                        <td height="30" align="right" rowspan="2">�ۼ��� : &nbsp;&nbsp;<%=item.get("ITEM_MAN")%> (<%=user_bean.getUser_m_tel()%>)</td>
                      </tr>
                      <tr> 
                        <td height="15" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="center" bgcolor="#CCCCCC"> 
                              <td rowspan="2" width="30" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                              <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ŷ�����</td>
                              <td rowspan="2" width="75" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">������ȣ</td>
                              <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">����</td>
                              <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�������Ⱓ</td>
                              <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">���ް���</td>
                              <td rowspan="2" width="55" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                              <td rowspan="2" width="65" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">�հ�</td>
                            </tr>
                            <tr> 
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                              <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                            </tr>
                            <%		for(int i = 0 ; i < 1 ; i++){
										Hashtable item1 = (Hashtable)items1.elementAt(i);%>
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_SEQ")%></font></td>
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%=item1.get("ITEM_G")%></font></td>
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
									<!--
                            <tr> 
                              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
                              <td colspan="5" height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1"><%//=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>��(��)*<%//=ma_bean.getIns_use_day()%>��*<%if(ti.getGubun().equals("11")){%>����<%=Math.abs(a_bean.getOur_fault_per()-100)%>%, ����:<%//=ma_bean.getIns_car_no()%><%}%></font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><font size="1">&nbsp;</font></td>
                              <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><font size="1">&nbsp;</font></td>
                            </tr>		
							-->							
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
                              <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>�հ�</b></font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_v_amt1)%>&nbsp;</font></td>
                              <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right"><font size="1"><%=Util.parseDecimal(item_s_amt1+item_v_amt1)%>&nbsp;</font></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan="2"><font size="1"><!--�� ����ٰ� : ������ ����--></font></td>
						<td align="right">(��)�Ƹ���ī</td>
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
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 575px; WIDTH: 68px; POSITION: absolute; TOP: 120px; HEIGHT: 68px"><IMG src='/images/cust/3c7kR522I6Sqs_70.gif'></DIV>
  </form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>