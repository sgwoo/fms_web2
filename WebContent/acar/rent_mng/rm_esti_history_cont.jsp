<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.estimate_mng.*, acar.secondhand.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");

	String s_cd 		= request.getParameter("s_cd")		==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");		
	String f_page 		= request.getParameter("f_page")	==null?"":request.getParameter("f_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
		
	String scd_rent_st 	= request.getParameter("scd_rent_st")	==null?"":request.getParameter("scd_rent_st");
	String scd_tm 		= request.getParameter("scd_tm")	==null?"":request.getParameter("scd_tm");
	
	String car_mng_id	= request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
	String tae_car_rent_st	= request.getParameter("tae_car_rent_st")	==null?"":request.getParameter("tae_car_rent_st");
	String tae_car_rent_et	= request.getParameter("tae_car_rent_et")	==null?"":request.getParameter("tae_car_rent_et");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	if(c_id.equals("")){
		c_id = car_mng_id;
	}
	


	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//30�� �̳� ��������Ʈ
	Vector vt = e_db.getEstimateRmCarContList(c_id, AddUtil.replace(tae_car_rent_st,"-",""));	
	int size = vt.size();
		

	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>

</script>
</head>
<body>

<form action="" name="form1" method="post" >
       
<table border=0 cellspacing=0 cellpadding=0 width=1000>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>�������/����Ʈ ���� �̷�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>������ȣ</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=15%>����</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NM")%></td>
                </tr>                                
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>����</td>
                    <td class=title>��������</td>
                    <td class=title>����������Ÿ�</td>
                    <td class=title>��������Ÿ�</td>
                    <td class=title>��������</td>                    
                    <td class=title>������</td>
                    <td class=title>������</td>
                    <td class=title>���ô뿩��</td>
                    <td class=title>���ް�</td>
                    <td class=title>�ΰ���</td>
                    <td class=title>���뿩��</td>
                    <td class=title>�����<br>���� �뿩<br>��� ������<br>��� ����<br>(�ΰ�������)</td>
                </tr>
                <%for(int i = 0 ; i < size ; i++){
	    			Hashtable ht = (Hashtable)vt.elementAt(i);
    			
    				String td_color="";
    				if(tae_car_rent_st.equals(AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT"))))){
    					td_color="class=is";
    				}
    			%>
                <tr> 
                    <td <%=td_color%> align=center><%=ht.get("ST")%></td>
                    <td <%=td_color%> align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td <%=td_color%> align=center><%=Util.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%>km</td>
                    <td <%=td_color%> align=center><%=Util.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%>km</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("O_1")))%>��</td>                    
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("RG_8")))%>��</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("PP_AMT")))%>��</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("IFEE_AMT")))%>��</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>��</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>��</td>
                    <td <%=td_color%> align=right><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��</td>          
                    <td <%=td_color%> align=right>
                        <%	if(AddUtil.parseInt(String.valueOf(ht.get("TAE_RENT_FEE_CLS"))) == 0 && String.valueOf(ht.get("ST")).equals("�������")){
	                        	Hashtable taeCarHt = shDb.getTaeCarRmAmt(String.valueOf(ht.get("EST_ID")));
    	    					int tae_car_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_S_AMT"))); //���������������
        						int tae_car_fee_v_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("FEE_V_AMT"))); //��������������� �ΰ���
        						int tae_car_fee_t_amt = tae_car_fee_s_amt + tae_car_fee_v_amt; //��������������� �ΰ��� �ջ� �ݾ�
        						int tae_car_r_rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("R_RM_FEE_S_AMT"))); //������������� ������� ��� (����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��) 
        						int tae_car_rm_fee_s_amt = AddUtil.parseInt(String.valueOf(taeCarHt.get("RM_FEE_S_AMT"))); //������������� ������� ��� (����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��)
        				%>
        				<%		if (tae_car_fee_t_amt < tae_car_rm_fee_s_amt) {%>
		            				<%=AddUtil.parseDecimal(tae_car_r_rm_fee_s_amt)%>��
		            	<%		}%>
        				<%	}else{%>
        							<%=Util.parseDecimal(String.valueOf(ht.get("TAE_RENT_FEE_CLS")))%>��
        				<%	} %>                    
                    </td>                             
                </tr>
                <%}%>
            </table>
        </td>
    </tr>   
    <tr>
	  <td>�� ����Ʈ ���ް� -1���� ������� ����Ʈ ������̰ų�, �����/���Ȯ�� �̰ų�, ����Ʈ ���� ������ ����Դϴ�.</td>
    </tr>   
    <tr>
	  <td>�� ����� ���� �뿩 ��� ������ ����Ʈ ������ = ����Ʈ���+����������������̵�Ź�۷�+�������������������ȿ��</td>
    </tr>   
    <tr>
	<td align="right">
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>        
</table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
