<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*, acar.estimate_mng.*, acar.cont.*, acar.client.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
		
	EstimateBean [] e_r = e_db.getEstimateRentDcList(rent_mng_id, rent_l_cd);
	int size = e_r.length;
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	String car_name	= "";
			
	for (int i = 0; i < 1; i++) {
		bean = e_r[i];
		car_name = bean.getCar_nm()+" "+ bean.getCar_name();
	}	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body leftmargin="15">
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��������DC</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=40%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=40%>&nbsp;<%=client.getFirm_nm()%></td>
    		    </tr>	
    		    <tr> 
                    <td class=title>����</td>
                    <td colspan='3'>&nbsp;<%=car_name%></td>
    		    </tr> 		    		    
                <tr> 
                    <td class=title>�̿�Ⱓ</td>
                    <td>&nbsp;<%=fee.getCon_mon()%>����</td>
                     <td class=title>���ʿ�����</td>
                    <td >&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
    		    </tr>
                <tr> 
                    <td class=title>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
                    <td class=title>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
    		    </tr>    
    		</table>
	    </td>
	</tr>     
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� ������� ���� �������� -30�� ~ +10��, Ʈ���ڵ�/�����/�̿�Ⱓ/������ ���� ��������</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    <td class=title width=15%>��ȣ �Ǵ� ����</td>
                    <td class=title width=10%>�Һ��ڰ�<br>�⺻����</td>
                    <td class=title width=10%>�Һ��ڰ�<br>�ɼ�</td>
                    <td class=title width=10%>�Һ��ڰ�<br>����</td>
                    <td class=title width=10%>DC�ݾ�</td>
                    <td class=title width=10%>��������</td>
                    <td class=title width=10%>���뿩��</td>					
                    <td class=title width=10%>������</td>
                    <td class=title width=10%>��������</td>					
    		    </tr>			
              			<%for (int i = 0; i < size; i++) {
    						bean = e_r[i];
    						String td_color = "";
    						
    						if(bean.getEst_nm().equals(client.getFirm_nm()) || fee.getFee_s_amt() == bean.getFee_s_amt()){
    							td_color = "class=is";
    						}
    					%>							
						<tr>
							<td align="center" <%=td_color%>><%=i+1%></td>
							<td <%=td_color%>>&nbsp;<%=bean.getEst_nm()%></td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getCar_amt())%>��</td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getOpt_amt())%>��</td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getCol_amt())%>��</td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getDc_amt())%>��</td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getO_1())%>��</td>
							<td align='right' <%=td_color%>><%if(fee.getFee_s_amt() == bean.getFee_s_amt()){%><font color=red><%}%><%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>��<%if(fee.getFee_s_amt() == bean.getFee_s_amt()){%></font><%}%></td>
							<td align='right' <%=td_color%>><%=Util.parseDecimal(bean.getGtr_amt())%>��</td>							
							<td align="center" <%=td_color%>><%= AddUtil.ChangeDate2(bean.getRent_dt()) %></td>							
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>    
			
</table>
</form>
</body>
</html>
