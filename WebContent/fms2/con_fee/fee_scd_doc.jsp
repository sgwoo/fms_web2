<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩���� ī����
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//��������� ��ȸ
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//�Ǻ� �뿩�� ������ ����Ʈ
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScd(l_cd);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdRentst(l_cd, rent_st, "");//fee.getPrv_mon_yn()
		fee_scd_size = fee_scd.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean h_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	
	UsersBean a_user = u_db.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../../include/print.css">
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
		factory1.printing.leftMargin=15;
		factory1.printing.rightMargin=15;
		<%if(fee_scd_size > 34){%>
		factory1.printing.topMargin=15;
		factory1.printing.bottomMargin=10;
		<%}else{%>
		factory1.printing.topMargin=20;
		factory1.printing.bottomMargin=15;
		<%}%>
		factory1.printing.Print(true, window);
	}
//-->
//-->
</script>
</head>
<body leftmargin="15" topmargin="10" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name="form1" method='post'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
  <table border='1' cellspacing='0' cellpadding='0' width='620'>
    <tr> 
      <td align="center" valign="middle" style="border-top: #99CC66 2px solid; border-left: #99CC66 2px solid; border-bottom: #99CC66 2px solid; border-right: #99CC66 2px solid;">
        <table width="600" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="14" height="15"></td>
          </tr>
          <tr align="center"> 
            <td colspan="14" style="font-size:14pt" height="30" bgcolor="#DFEFCF"><b>�Ƹ���ī 
              ���뿩 �̿� �ȳ���</b></td>
          </tr>
          <tr valign="bottom"> 
            <td colspan="7" height="30"  style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid; font-size=11pt"><b><%=base.get("FIRM_NM")%> ��</b></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3" align="right">�ۼ��� : <%= AddUtil.getDate() %></td>
          </tr>
          <tr> 
            <td width="19">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="35">&nbsp;</td>
            <td width="35">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="70">&nbsp;</td>
            <td width="4">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="70">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="70">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18"> <p>�ֻ��� ���񽺸� �����ϴ� ��ⷻƮ���� ȸ�� (��)�Ƹ���ī�� 
                �̿��� �ּż� �����մϴ�.</p></td>
          </tr>
          <tr> 
            <td colspan="14" height="18">������ ������ �̿��Ͻ� ���� (��)�Ƹ���ī���� ������� �� �뿩��� 
              �����Դϴ�. </td>
          </tr>
          <tr> 
            <td colspan="14" height="18">������ �����Ͻñ� �ٶ��ϴ�.</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">�� ������</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">�뿩����</td>
            <td colspan="3"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">���뿩��(VAT����)</td>
            <td colspan="4"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">���뿩������</td>
            <td colspan="2"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">���ô뿩��(VAT����)</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="25"  style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=7pt" ><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%= Util.parseDecimal(fee.getFee_s_amt()) %>��</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>��</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">�뿩�Ⱓ</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">�뿩������</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">�뿩������</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">���</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="25" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getCon_mon()%>����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getRent_start_dt()%></td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getRent_end_dt()%></td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=base.get("CAR_NO")%></td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">�� �뿩�� �Ա� �ȳ�</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">������ �뿩�� �������� �ſ� <span style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid; font-size=11pt">&nbsp;<b><%if(fee.getFee_est_day().equals("99")){%>����<%}else{%><%= fee.getFee_est_day() %><%}%></b>&nbsp;</span> ���Դϴ�.</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">�� ������ ������ ���Ͻô� ��� (��)�Ƹ���ī �ѹ��� (Tel.02-392-4243)���� 
              ��û �� �ֽñ� �ٶ��ϴ�.</td>
          </tr>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">(������ ���� ������ �뿩�� 
              ���� ��� û���� �߻� �� �� �ֽ��ϴ�. �Ա����ڰ� ������/�ָ��� ��� ������ �Ա������Դϴ�.)</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">�� �뿩�� �Ա� ������</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" align="center" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">ȸ��</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF" colspan="2">�Ա�����</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���ް�</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�ΰ���</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���뿩��</td>
            <td>&nbsp;</td>
            <td colspan="2" align="center" height="20" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">ȸ��</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�Ա�����</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���ް�</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�ΰ���</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���뿩��</td>
          </tr>
        <% 	if(fee_scd_size>0){
				int h_size = Math.round(fee_scd_size/2);
				if(fee_scd_size%2 != 0){
					h_size = h_size+1;
				}
				for(int i = 0 ; i < h_size ; i++){
					FeeScdBean fee1 = (FeeScdBean)fee_scd.elementAt(i);
					FeeScdBean fee2 = new FeeScdBean();
					if(i+h_size < fee_scd_size){
						fee2 = (FeeScdBean)fee_scd.elementAt(i+h_size);
					}
			%>
          <tr> 
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt" <%if(fee_scd_size > 34){%>height="13"<%}else{%>height="17"<%}%>><%if(fee1.getTm_st2().equals("2")){%>b<%}%><%//= i+1 %><%=fee1.getFee_tm()%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%if(!fee1.getRc_yn().equals("1")){ out.print("V"); }else{ out.print("&nbsp;"); }%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt" colspan="2">&nbsp;<%=AddUtil.ChangeDate2(fee1.getFee_est_dt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_s_amt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_v_amt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_s_amt()+fee1.getFee_v_amt())%>&nbsp;</td>
            <td>&nbsp;</td>
			<%if(fee_scd_size%2 != 0 && i+h_size+1 > fee_scd_size){%>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
			<%}else{%>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%//= i+h_size+1 %><%=fee2.getFee_tm()%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><% if(!fee2.getRc_yn().equals("1")){ out.print("V"); }else{ out.print("&nbsp;"); }%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">&nbsp;<%= AddUtil.ChangeDate2(fee2.getFee_est_dt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_s_amt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_v_amt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_s_amt()+fee2.getFee_v_amt()) %>&nbsp;</td>
			<%}%>
          </tr>
          <% }
		  	}else{  %>
          <tr> 
            <td height="17" colspan="7" align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">-</td>
            <td>&nbsp;</td>
            <td colspan="6" align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">-</td>
          </tr>
          <% } %>
		  <%if(tae_sum>0){%>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">(ȸ���� b�� ǥ�õ� ���� <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>�����Ī����<%}else{%>���������<%}%> �������Դϴ�.)</td>
          </tr>
		  <%}%>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
		  <%if(cms.getRent_l_cd().equals("")){%>
          <tr> 
            <td colspan="10" height="23" style="font-size:10pt">�� �Աݹ�� : �¶��� ������ü 
              (�� �ڵ���ü �̽�û ��)
			</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2" align="right">������ : (��)�Ƹ���ī</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���¹�ȣ</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���¹�ȣ</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">�ϳ�����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">140-910014-53104</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">��������</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">385-01-0026-124</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">��������</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">140-004-023871</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">��Ƽ����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">163-01374-242</td>
          </tr>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">�� ������� �� ���Ͻô� ������ 
              ���θ� ��Ź�帮��, �ڵ���ü ��û�� ���Ͻô� ��� ���� �Ƹ���ī�� ���� �� �ֽñ� �ٶ��ϴ�.</td>
          </tr>
		  <%}else{%>
          <tr> 
            <td colspan="10" height="23" style="font-size:10pt">�� �Աݹ�� : �ڵ���ü</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2" align="right"></td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">�����</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">���¹�ȣ</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">����������</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">������������</td>
            <td style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">��ü��</td>			
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt"><%=cms.getCms_bank()%></td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt"><%=cms.getCms_acc_no()%></td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%></td>
            <td style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">�ſ� <%=cms.getCms_day()%>��</td>			
          </tr>
		  <%}%>
          <tr> 
            <td height="15" colspan="14">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">���� (��)�Ƹ���ī�� ���� ���������� ���Ͽ� ������ �������� ���񽺷� 
              �ּ��� ���ϰ� �ֽ��ϴ�.</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" height="20" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid;">������� 
              : <%=h_user.getUser_nm()%> (HP. <%=h_user.getUser_m_tel()%>)</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" height="20" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid;">ȸ���� 
              : <%=a_user.getUser_nm()%> (Tel. <%=a_user.getHot_tel()%>)</td>
          </tr>
          <tr> 
            <td colspan="14" height="8"></td>
          </tr>
          <tr> 
            <td colspan="4"><font color="#FF0000"><img src="/acar/images/logo_1.png" width="75" height="20" border="0"></font></td>
            <td colspan="10" style="font-size:7pt" valign="bottom">(��)�Ƹ���ī : Tel.02)757-0802 
              Fax.02)757-0803 / ���� �������� ���ǵ��� 17-3 / http://www.amazoncar.co.kr</td>
          </tr>
          <tr> 
            <td colspan="14" height="15"></td>
          </tr>
        </table>
    </tr>
  </table>
  </form>
</body>
</html>
