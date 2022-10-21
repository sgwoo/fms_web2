<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.bill_mng.*, acar.user_mng.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	
	co_bean = cod.getCarOffBean(car_off_id);
	
	//������Ʈ
	CarOffEmpBean coe_r [] = cod.getCarAgentEmpAll(car_off_id);
	
	//���ٸ���
	CarOffEmpBean coe_r2 [] = cod.getCarOffEmpAll(car_off_id);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function CarOffUpd(){
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "car_agent_u.jsp";
		fm.submit();	
	}
	
	function go_list(){
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "car_agent_frame.jsp";
		fm.submit();
	}

	//�������
	function reg_cont_emp(){
		var fm = document.form1;
		window.open("/fms2/lc_rent/reg_emp_i.jsp?car_off_id=<%=car_off_id%>&from_page=car_agent_c.jsp", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");
	}
	
	function emp_sanction(cmd, emp_id){
		var fm = document.form1;
		fm.cmd.value = cmd;
		fm.emp_id.value = emp_id;		
		if(!confirm('���ó���Ͻðڽ��ϱ�?'))	return;
		fm.target = "i_no";
		fm.action = "/fms2/lc_rent/reg_emp_d_a.jsp";
		fm.submit();			
	}
	
//-->
</script>
</head>
<body>
<form action="./car_agent_u.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="car_off_id" value="<%=car_off_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="emp_id" value="">
<input type="hidden" name="from_page" value="car_agent_c.jsp">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>������Ʈ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align=right>
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
            <a href="javascript:CarOffUpd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_s.gif align=absmiddle border=0></a>&nbsp;
            <%}%>
	    <a href="javascript:go_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>
                    <td class=title>������Ʈ������ȣ</td>
               	    <td colspan=5>&nbsp;
               		<%=car_off_id%></td>
                </tr>  
            	<tr>			    	
                    <td width=12% class=title>��������</td>
		    <td width=20%>&nbsp;
		        <%if(co_bean.getCar_off_st().equals("3")){%>����<%}%>
                    	<%if(co_bean.getCar_off_st().equals("4")){%>���λ����<%}%>
		    </td>			    	
		    <td width=12% class=title>�Ҽӱ���</td>
                    <td width=24%>&nbsp;
                    	<%if(co_bean.getAgent_st().equals("1")){%>������Ʈ<%}%>
                    	<%if(co_bean.getAgent_st().equals("2")){%>��������<%}%>
                    </td>
                    <td class=title width=12%>���ʵ����</td>
                    <td width=20%>&nbsp;
                        <%=AddUtil.ChangeDate2(co_bean.getReg_dt())%></td>                    
		</tr>
            	<tr>			    	
                    <td width=12% class=title>��������</td>
					<td>&nbsp;
		        <%if(co_bean.getWork_st().equals("E")){%>������
		        <%}else{%>����,��� ���
		        <%}%>
					 </td>	
					 <td width=12% class=title>�ŷ�����</td>
					 <td colspan='3'>&nbsp;
		        <%if(co_bean.getUse_yn().equals("Y")){%>�ŷ�
		        <%}else{%>�̰ŷ�
		        <%}%>
					 </td>	
		</tr>			
                <tr>                    
                    <td class=title>��ȣ/����</td>
		    <td>&nbsp;
		        <%=co_bean.getCar_off_nm()%></td>			    	
                    <td class=title>����ڱ���</td>
               	    <td>&nbsp;
                    	<%if(co_bean.getEnp_st().equals("1")){%>����<%}%>
                    	<%if(co_bean.getEnp_st().equals("2")){%>����<%}%>
                    </td>
               	    <td class=title>�����/�ֹι�ȣ</td>
               	    <td>&nbsp;
               	        <%=AddUtil.ChangeEnpH(co_bean.getEnp_no())%></td>                    
                </tr>		
                <tr>                    
                    <td class=title>��ǥ��</td>
		    <td>&nbsp;
		        <%=co_bean.getOwner_nm()%></td>			    	
                    <td class=title>��ǥ��ȭ</td>
               	    <td>&nbsp;
               	        <%=co_bean.getCar_off_tel()%></td>
               	    <td class=title>�ѽ�</td>
               	    <td>&nbsp;
               	        <%=co_bean.getCar_off_fax()%></td>                    
                </tr>
                <tr>
                    <td class=title>�ּ�</td>
               	    <td colspan=5>&nbsp;
               		<%=co_bean.getCar_off_post()%>&nbsp;<%=co_bean.getCar_off_addr()%></td>
                </tr>    
            </table>
        </td>
    </tr>    
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr id=tr_pay_way style="display:<%if(co_bean.getWork_st().equals("C")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>����ڵ�ϱ���</td>
		    <td width=20%>&nbsp;
		        <%if(co_bean.getEnp_reg_st().equals("1")){%>����ڵ�ϻ����<%}%>
                    	<%if(co_bean.getEnp_reg_st().equals("2")){%>����ڹ̵����<%}%>
		    </td>			    	
		    <td width=12% class=title>�ŷ�����</td>
                    <td width=24%>&nbsp;
                    	<%if(co_bean.getDoc_st().equals("1")){%>��õ¡��<%}%>
                    	<%if(co_bean.getDoc_st().equals("2")){%>���ݰ�꼭<%}%>
                    </td>
                    <td class=title width=12%>����������</td>
                    <td width=20%>&nbsp;
                    	<%if(co_bean.getEst_day().equals("")){%>����<%}%>
                    	<%if(!co_bean.getEst_day().equals("")){%>�ſ�<%=co_bean.getEst_day()%>��<%}%>
                    	<!--
                    	(
                    	<%if(co_bean.getEst_mon_st().equals("1")){%>�Ϳ�<%}%>
                    	<%if(co_bean.getEst_mon_st().equals("0")){%>���<%}%>
                    	)
                    	-->
                    </td>
		</tr>                                            
                <tr>
                    <td class=title>�ŷ�ó�ڵ�</td>
               	    <td>&nbsp;
               	        <%=co_bean.getVen_code()%>
               	    </td>
               	    <td class=title>���ݰ�꼭<br>���뱸��</td>
               	    <td>&nbsp;
		        <%if(co_bean.getReq_st().equals("1")){%>����<%}%>
                    	<%if(co_bean.getReq_st().equals("2")){%>����<%}%>
                    	<%if(co_bean.getReq_st().equals("3")){%>����<%}%>
		    </td>			
               	    <td class=title>���ޱ���</td>
               	    <td>&nbsp;
		        <%if(co_bean.getPay_st().equals("1")){%>����<%}%>
                    	<%if(co_bean.getPay_st().equals("2")){%>�����Ǻ�<%}%>
		    </td>			
                </tr>                     
                <tr>
                    <td class=title>�ŷ�����</td>
               	    <td>&nbsp;
		        <%=co_bean.getBank()%>					
               	    </td>
               	    <td class=title>���¹�ȣ</td>
               	    <td>&nbsp;
               	        <%=co_bean.getAcc_no()%></td>
               	    <td class=title>������</td>
               	    <td>&nbsp;
               	        <%=co_bean.getAcc_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>    	
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            	    <td width=10% class=title>������ȣ</td>
            		<td width=12% class=title>����</td>
            		<td width=10% class=title>�μ�</td>
            		<td width=10% class=title>����</td>
            		<td width=20% class=title>������</td>
            		<td width=18% class=title>����ó</td>
            		<td width=20% class=title>�����ּ�</td>
            		
            	</tr>
<%
    for(int i=0; i<coe_r.length; i++){
        coe_bean = coe_r[i];
%>
            	<tr>
            		<td align=center><%= coe_bean.getEmp_id() %></td>
            		<td align=center><%= coe_bean.getEmp_nm() %></td>
            		<td align=center><%= coe_bean.getEmp_dept() %></td>
            		<td align=center><%= coe_bean.getEmp_pos() %></td>
            		<td align=center><%= coe_bean.getEtc() %></td>
            		<td align=center><%= coe_bean.getEmp_m_tel() %></td>
            		<td>&nbsp;<%= coe_bean.getEmp_email() %></td>
            	</tr>
<%}%>
<% if(coe_r.length == 0) { %>
                <tr>
                    <td colspan=7 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
<%}%>
            </table>
        </td>
    </tr>  
    <tr>
    	<td>&nbsp;</td>    	
    </tr>      
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �������</span></td>    	
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td width=10% class=title>������ȣ</td>
            		<td width=12% class=title>����</td>
            		<td width=10% class=title>�μ�</td>
            		<td width=10% class=title>����</td>
            		<td width=20% class=title>������</td>
            		<td width=18% class=title>����ó</td>
            		<td width=15% class=title>�����ּ�</td>
            		<td width=5% class=title>-</td>            		
            	</tr>
<%
    for(int i=0; i<coe_r2.length; i++){
        coe_bean = coe_r2[i];
        if(!coe_bean.getAgent_id().equals("")) continue;
%>
            	<tr>
            		<td align=center><%= coe_bean.getEmp_id() %></td>
            		<td align=center><%= coe_bean.getEmp_nm() %></td>
            		<td align=center><%= coe_bean.getEmp_dept() %></td>
            		<td align=center><%= coe_bean.getEmp_pos() %></td>
            		<td align=center><%= coe_bean.getEtc() %></td>
            		<td align=center><%= coe_bean.getEmp_m_tel() %></td>
            		<td>&nbsp;<%= coe_bean.getEmp_email() %></td>
            		<td align=center><%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><a href="javascript:emp_sanction('d','<%=coe_bean.getEmp_id()%>')" onMouseOver="window.status=''; return true" title='���ó��'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%></td>
            	</tr>
<%}%>
<% if(coe_r.length == 0) { %>
                <tr>
                    <td colspan=8 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
<%}%>
            </table>
        </td>
    </tr>  
    <tr>
    	<td align=right>
        <a href="javascript:reg_cont_emp()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>      
    	</td>    	
    </tr>       
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>