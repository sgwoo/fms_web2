<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_br 	= request.getParameter("s_br")==null?"":request.getParameter("s_br");
	String chk1 	= request.getParameter("chk1")==null?"":request.getParameter("chk1");
	String chk2 	= request.getParameter("chk2")==null?"":request.getParameter("chk2");
	String chk3 	= request.getParameter("chk3")==null?"":request.getParameter("chk3");
	String chk4 	= request.getParameter("chk4")==null?"":request.getParameter("chk4");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String gubun8 	= request.getParameter("gubun8")==null?"":request.getParameter("gubun8");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd1 	= request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 	= request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	String cgs_ok 	= request.getParameter("cgs_ok")==null?"":request.getParameter("cgs_ok");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String venName = "";
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vts = CardDb.getCardDocSearchListScard(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, gubun8, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc, cgs_ok);
	
	int vt_size = vts.size();
	
	long total_amt = 0;	
	long total_s_amt = 0;	
	long total_v_amt = 0;	
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "08");
	
	   
	if(vt_size > 0){
			 
		for(int i=0; i < vt_size; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			if(!from_page.equals("/cons_doc_reg_i.jsp")){
				venName = ht.get("VEN_NAME")+"^javascript:CardDocUpd(&#39;"+ht.get("CARDNO")+"&#39;, &#39;"+ht.get("BUY_ID")+"&#39;, &#39;"+ht.get("DOC_MNG_ID")+"&#39;, &#39;"+ht.get("BUY_USER_ID")+"&#39;, &#39;"+ht.get("USER_ID")+"&#39;);^_self";
			}else{
				venName = ht.get("VEN_NAME")+"^javascript:setCardCode(&#39;"+ht.get("CARDNO")+"&#39;, &#39;"+ht.get("CARD_NAME")+"&#39;, &#39;"+ht.get("CARD_SDATE")+"&#39;, &#39;"+ht.get("CARD_EDATE")+"&#39;, &#39;"+ht.get("BUY_DT")+"&#39;, &#39;"+ht.get("VEN_NAME")+"&#39;, &#39;"+ht.get("VEN_CODE")+"&#39;, &#39;"+ht.get("BUY_S_AMT")+"&#39;, &#39;"+ht.get("BUY_V_AMT")+"&#39;, &#39;"+ht.get("BUY_AMT")+"&#39;, &#39;"+ht.get("BUY_ID")+"&#39;);^_self";
			}
			String buySt = ht.get("BUY_ST")+"^javascript:CardDocHistory(&#39;"+ht.get("VEN_CODE")+"&#39;, &#39;"+ht.get("CARDNO")+"&#39;, &#39;"+ht.get("BUY_ID")+"&#39;, &#39;"+ht.get("BUY_ST")+"&#39;);^_self";
			
			//������� ǥ�� : ������ ���� ��� ����, ����ڸ� ���� ��� �̽���, ��� ���� ��� �̵��, app_id�� ���� cancel�� ��� �������
			
			String app_st = "";
			
			 if(!ht.get("APP_ID").equals("")){
				if(ht.get("APP_ID").equals("cancel")) app_st="�������";
				else if(ht.get("APP_ID").equals("cance0")) app_st="�������";
				else app_st="����";
			}else{
				if(!ht.get("REG_ID").equals("")) app_st="�̽���";
				else app_st="�̵��";
			}
%>
		
		<row  id='<%=i+1%>'>
			<cell><![CDATA[]]></cell><!--üũ�ڽ�0-->
			<cell><![CDATA[<%=i+1%>]]></cell><!--����1-->
 	 		<cell><![CDATA[<%=app_st%>]]></cell><!--����2-->
	 	 	<cell><![CDATA[<%=ht.get("CARDNO")%>]]></cell><!--ī���ȣ3-->
 	 		<cell><![CDATA[<%=ht.get("OWNER_NM")%>]]></cell><!--������4-->
	 	 	<cell><![CDATA[<%=ht.get("USER_NM")%>]]></cell><!--�����5-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%>]]></cell><!--�ŷ�����6-->
			<cell><![CDATA[<%=venName%>]]></cell><!--�ŷ�ó7-->			
	 	 	<cell><![CDATA[<%=buySt%>]]></cell><!--��������8-->
			<cell><![CDATA[<%=ht.get("BUY_S_AMT")%>]]></cell><!--���ް�9-->	
			<cell><![CDATA[<%=ht.get("BUY_V_AMT")%>]]></cell><!--�ΰ���10-->
	 	 	<cell><![CDATA[<%=ht.get("BUY_AMT")%>]]></cell><!--�ݾ�11-->
	 		<cell><![CDATA[<%=ht.get("ACCT_CODE_NM")%>]]></cell><!--��������12-->
	 		<cell><![CDATA[<%=ht.get("ACCT_CODE_G_NM")+""+ht.get("ACCT_CODE_G2_NM")%>]]></cell><!--����13-->			
	 	 	<cell><![CDATA[<%=ht.get("ACCT_CODE_G_NM")+""+ht.get("ACCT_CODE_G2_NM")%>]]></cell><!--����14-->
			<cell><![CDATA[<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>]]></cell><!--�����15-->	
			<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>]]></cell><!--�������16-->
	 	 	<cell><![CDATA[<%=c_db.getNameById(String.valueOf(ht.get("APP_ID")),"USER")%>]]></cell><!--������17-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("APP_DT")))%>]]></cell><!--��������18-->
	 		<cell><![CDATA[<%=ht.get("CARDNO")%><%=ht.get("BUY_ID")%>]]></cell><!-- ī�庯�� �� �ѱ� ������ 19-->
	 	</row>
	<%}
	}%>

</rows>
