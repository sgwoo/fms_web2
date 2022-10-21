<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String doc_id 		= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq_no 		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���·Ḯ��Ʈ
	FineDocListBn = FineDocDb.getAccidMyDocList(doc_id, car_mng_id, seq_no);
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�����ϱ�
	function fine_update(){
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "accid_mydoc_mng_list_u_a.jsp";
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='seq_no' value='<%=seq_no%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>���ǽ�û���� ����Ʈ ����</span></span></td>
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
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	          <tr> 
        	    <td width="10%" rowspan="2" class='title'>���������ȣ</td>
            	<td colspan="3" class='title'>�����̿���</td>
	            <td width="8%" rowspan="2" class='title'>������ȣ</td>
    	        <td width="12%" rowspan="2" class='title'>����</td>			
        	    <td colspan="3" class='title'>�����Ⱓ</td>						
            	<td width="8%" rowspan="2" class='title'>������<br>û���ݾ�</td>
    	      </tr>
        	  <tr>
	            <td width="16%" class='title'>����</td>
    	        <td width="10%" class='title'>����ڹ�ȣ</td>
    	        <td width="10%" class='title'>�������/���ι�ȣ</td>				
        	    <td width="9%" class='title'>��������</td>
            	<td width="9%" class='title'>��������</td>
	            <td width="8%" class='title'>������</td>
    	      </tr>			
                <tr align="center"> 
                    <td><input type="text" name="paid_no" size="14" class="text" value="<%=FineDocListBn.getPaid_no()%>"></td>
                    <td><input type="text" name="firm_nm" size="25" class="text" value="<%=FineDocListBn.getFirm_nm()%>"></td>					
                    <td><input type="text" name="enp_no" size="13" class="text" value="<%=FineDocListBn.getEnp_no()%>"></td>					
                    <td><input type="text" name="ssn" size="13" class="text" value="<%if(FineDocListBn.getSsn().substring(0,1).equals("1")){%><%=FineDocListBn.getSsn()%><%}else{%><%if(unFormat.length()>5){%><%=FineDocListBn.getSsn().substring(0,6)%><%}%><%}%>"></td>					
                    <td><input type="text" name="car_no" size="10" class="text" value="<%=FineDocListBn.getCar_no()%>"></td>					
                    <td><input type="text" name="car_nm" size="18" class="text" value="<%=FineDocListBn.getVar3()%>"></td>										
                    <td><input type="text" name="rent_start_dt" size="12" class="text" value="<%=FineDocListBn.getRent_start_dt()%>"></td>
					<td><input type="text" name="rent_end_dt" size="12" class="text" value="<%=FineDocListBn.getRent_end_dt()%>"></td>
					<td><input type="text" name="use_day" size="10" class="text" value="<%=FineDocListBn.getVar2()%>"></td>					
					<td><input type="text" name="amt1" size="8" class="num" value="<%=FineDocListBn.getAmt1()%>">��</td>										
                </tr>
            </table>
        </td> 
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    
        <td align="center" >
		  <%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){%>
	  	 	  <a href="javascript:fine_update();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>
		  <%}%>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
