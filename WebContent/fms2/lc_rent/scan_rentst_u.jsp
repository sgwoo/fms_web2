<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String path = "D:\\Inetpub\\wwwroot\\data\\"+AddUtil.getDate(1) +"\\";
	/* multipart/form-data �� FileUpload��ü ���� */ 
	FileUpload file = new FileUpload(path, request.getInputStream());
	
	//��ĵ���� ������
	
	String auth_rw 	= file.getParameter("auth_rw")==null?"":file.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");

	String m_id 	= file.getParameter("m_id")==null?"":file.getParameter("m_id");
	String l_cd 	= file.getParameter("l_cd")==null?"":file.getParameter("l_cd");
	String rent_st 	= file.getParameter("rent_st")==null?"1":file.getParameter("rent_st");
	String brch_id 	= file.getParameter("brch_id")==null?"":file.getParameter("brch_id");
	String br_id 	= file.getParameter("br_id")==null?"":file.getParameter("br_id");
	String file_st = "";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	String user_id = login.getCookieValue(request, "acar_id");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//������ȣ �̷�
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//����ϱ�
	function save(){
		fm = document.form1;		
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		fm.target = "i_no";
		fm.action = "scan_rentst_u_a.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="fee_size" value="<%=fee_size%>">    
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��ĵ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='20%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='50%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
                <tr>
                    <td class=h colspan='4'></td>
                </tr>				
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
//						ContCarBean fee_etcs = a_db.getContFeeEtc(m_id, l_cd, Integer.toString(i));%>
                <tr> 
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>����<%if(i>1){%>(����)<%}%></td>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                </tr>						
				<%}%>		
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='12%'>���</td>
                    <td class="title" width='25%'>����</td>
                    <td class="title" width='30%'>����</td>
                    <td class="title" width='18%'>���Ϻ���</td>
                    <td class="title" width='10%'>�����</td>
                </tr>

            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td align="right">
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <%}%>
        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
