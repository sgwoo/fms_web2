<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��äó �ֱ� ��� ����
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	ContBaseBean base1 = a_db.getRecentCont(client_id);
	
	if(rent_mng_id.equals(""))	rent_mng_id = base1.getRent_mng_id();
	if(rent_l_cd.equals(""))	rent_l_cd 	= base1.getRent_l_cd();
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//�ſ������� - ����
	Vector evals_1  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "1" );
	int eval1_size = evals_1.size();
	
	//�ſ������� - ��ǥ�̻�
	Vector evals_2  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "2" );
 	int eval2_size = evals_2.size();
 
	//�ſ������� - ����
	Vector evals_3  = a_db.getContEvalList(rent_mng_id, rent_l_cd, "3" );
	int eval3_size = evals_3.size();
	
	//�ſ������� - ������
	Vector evals_4  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "4" );
	int eval4_size = evals_4.size();
	
	//���繫��ǥ
	ClientFinBean c_fin = new ClientFinBean();
	
	if(cont_etc.getFin_seq().equals("")){
		c_fin = al_db.getClientFin(client_id);
	}else{
		c_fin = al_db.getClientFin(base.getClient_id(), cont_etc.getFin_seq());
	}
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function set_eval()
	{
	 	    
	    if ( <%=eval1_size%> > 0 ||  <%=eval2_size%> > 0 || <%=eval3_size%> > 0 || <%=eval4_size%> > 0 ) {
	    
				   	var fm = document.form1;
				   	
				   	
				   	if ( <%=eval1_size%> > 0 ) {
						//����   	
						window.opener.form1.eval_gu[0].value	 = fm.eval_gu[0].value;
						window.opener.form1.eval_nm[0].value 	 = fm.eval_nm[0].value;	
						window.opener.form1.eval_gr[0].value	 = fm.eval_gr[0].value;
						window.opener.form1.eval_off[0].value	 = fm.eval_off[0].value;	
						window.opener.form1.eval_s_dt[0].value 	 = fm.eval_s_dt[0].value;
						window.opener.form1.eval_b_dt[0].value 	 = fm.eval_b_dt[0].value;
						window.opener.form1.ass1_type[0].value	 = fm.ass1_type[0].value;
						window.opener.form1.t_addr[0].value	 = fm.ass1_addr[0].value;	
						window.opener.form1.t_zip[0].value	 = fm.ass1_zip[0].value;
						window.opener.form1.ass2_type[0].value	 = fm.ass2_type[0].value;	
						window.opener.form1.t_addr[1].value	 = fm.ass2_addr[0].value;
						window.opener.form1.t_zip[1].value	 = fm.ass2_zip[0].value;
					}										
					
					if ( <%=eval2_size%> > 0 ) {
						//��ǥ�̻�   	
						window.opener.form1.eval_gu[1].value = fm.eval_gu[1].value;
						window.opener.form1.eval_nm[1].value = fm.eval_nm[1].value;	
						window.opener.form1.eval_gr[1].value = fm.eval_gr[1].value;
						window.opener.form1.eval_off[1].value = fm.eval_off[1].value;	
						window.opener.form1.eval_s_dt[1].value = fm.eval_s_dt[1].value;
						window.opener.form1.eval_b_dt[1].value = fm.eval_b_dt[1].value;
						window.opener.form1.ass1_type[1].value	 = fm.ass1_type[1].value;
						window.opener.form1.t_addr[2].value	 = fm.ass1_addr[1].value;	
						window.opener.form1.t_zip[2].value	 = fm.ass1_zip[1].value;
						window.opener.form1.ass2_type[1].value	 = fm.ass2_type[1].value;	
						window.opener.form1.t_addr[3].value	 = fm.ass2_addr[1].value;
						window.opener.form1.t_zip[3].value	 = fm.ass2_zip[1].value;
					}										
				
						//�����   	
					if ( <%=eval3_size%> > 0 ) {
						window.opener.form1.eval_gu[0].value = fm.eval_gu[0].value;
						window.opener.form1.eval_nm[0].value = fm.eval_nm[0].value;	
						window.opener.form1.eval_gr[0].value = fm.eval_gr[0].value;
						window.opener.form1.eval_off[0].value = fm.eval_off[0].value;	
						window.opener.form1.eval_s_dt[0].value = fm.eval_s_dt[0].value;
						window.opener.form1.eval_b_dt[0].value = fm.eval_b_dt[0].value;
						window.opener.form1.ass1_type[0].value	 = fm.ass1_type[0].value;
						window.opener.form1.t_addr[0].value	 = fm.ass1_addr[0].value;	
						window.opener.form1.t_zip[0].value	 = fm.ass1_zip[0].value;
						window.opener.form1.ass2_type[0].value	 = fm.ass2_type[0].value;	
						window.opener.form1.t_addr[1].value	 = fm.ass2_addr[0].value;
						window.opener.form1.t_zip[1].value	 = fm.ass2_zip[0].value;
					}
															
					if ( <%=eval4_size%> > 0 ) {
						if ( <%=eval3_size%> > 0 ) {				
							//������   	
							for (i = 0; i < <%=eval4_size%>; i++) { 
								window.opener.form1.eval_gu[i+1].value = fm.eval_gu[i+1].value;
								window.opener.form1.eval_nm[i+1].value = fm.eval_nm[i+1].value;	
								window.opener.form1.eval_gr[i+1].value = fm.eval_gr[i+1].value;
								window.opener.form1.eval_off[i+1].value = fm.eval_off[i+1].value;	
								window.opener.form1.eval_s_dt[i+1].value = fm.eval_s_dt[i+1].value;
								window.opener.form1.eval_b_dt[i+1].value = fm.eval_b_dt[i+1].value;
								
								window.opener.form1.ass1_type[i+1].value	 = fm.ass1_type[i+1].value;
								window.opener.form1.t_addr[i+2].value	 = fm.ass1_addr[i+1].value;	
								window.opener.form1.t_zip[i+2].value	 = fm.ass1_zip[i+1].value;
								window.opener.form1.ass2_type[i+1].value	 = fm.ass2_type[i+1].value;	
								window.opener.form1.t_addr[i+3].value	 = fm.ass2_addr[i+1].value;
								window.opener.form1.t_zip[i+3].value	 = fm.ass2_zip[i+1].value;
																	
							}
						} else {
							//������   	
							for (i = 0; i < <%=eval4_size%>; i++) { 
								window.opener.form1.eval_gu[i+2].value = fm.eval_gu[i+2].value;
								window.opener.form1.eval_nm[i+2].value = fm.eval_nm[i+2].value;	
								window.opener.form1.eval_gr[i+2].value = fm.eval_gr[i+2].value;
								window.opener.form1.eval_off[i+2].value = fm.eval_off[i+2].value;	
								window.opener.form1.eval_s_dt[i+2].value = fm.eval_s_dt[i+2].value;
								window.opener.form1.eval_b_dt[i+2].value = fm.eval_b_dt[i+2].value;
								
								window.opener.form1.ass1_type[i+2].value	 = fm.ass1_type[i+2].value;
								window.opener.form1.t_addr[i+4].value	 = fm.ass1_addr[i+2].value;	
								window.opener.form1.t_zip[i+4].value	 = fm.ass1_zip[i+2].value;
								window.opener.form1.ass2_type[i+2].value	 = fm.ass2_type[i+2].value;	
								window.opener.form1.t_addr[i+5].value	 = fm.ass2_addr[i+2].value;
								window.opener.form1.t_zip[i+5].value	 = fm.ass2_zip[i+2].value;
																	
							}
						}	
							
					}
								
		} else {
		
			alert ("�ֱ� ����Ÿ�� �����ϴ�. �ڷḦ ������ �� �����ϴ�.!! �ڷḦ �Է��ϼ���.!!");
				
		}
		
		window.close();
		
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<p>
<form name='form1' action='search_eval.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='str' value='<%=str%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>	
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�ſ��򰡺���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ſ����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="13%" class=title>����</td>
                  <td width="16%" class=title>��ȣ/����</td>
                  <td width="12%" class=title>�������</td>
                  <td width="13%" class=title>�ſ�����</td>
                  <td width="16%" class='title'>�ſ���</td>
                  <td width="16%" class='title'>��(����)����</td>					
                  <td width="16%" class='title'>��ȸ����</td>
                </tr>
              <%if(client.getClient_st().equals("2")){%>
              
              <%if(eval3_size > 0){
    		  		for(int i = 0 ; i < eval3_size ; i++){
    				Hashtable eval_3 = (Hashtable)evals_3.elementAt(i);%>	
                <tr>
                    <td class=title>�����<input type='hidden' name='eval_gu' value='3'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_3.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                         <option value='1' readonly <%if( (eval_3.get("EVAL_OFF")).equals("1")) out.println("selected");%>>ũ��ž</option>
                         <option value='2' readonly <%if( (eval_3.get("EVAL_OFF")).equals("2")) out.println("selected");%>>NICE</option>
                         <option value='3' readonly <%if( (eval_3.get("EVAL_OFF")).equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><input type='text' name='eval_score' size='12' class='text' value='<%=eval_3.get("EVAL_SCORE")%>' readonly ></td>
                    <td align="center">
                    	<% if( String.valueOf(eval_3.get("EVAL_OFF")).equals("3")){
                    		String eval_gr = "";
                    		String scope = "";
                    		String grade = String.valueOf(eval_3.get("EVAL_GR"));
            				switch(grade){
            					case "1": scope = "(955~1000)"; break;
            					case "2": scope = "(907~954)"; break;
            					case "3": scope = "(837~906)"; break;
            					case "4": scope = "(770~836)"; break;
            					case "5": scope = "(693~769)"; break;
            					case "6": scope = "(620~692)"; break;
            					case "7": scope = "(535~619)"; break;
            					case "8": scope = "(475~534)"; break;
            					case "9": scope = "(390~474)"; break;
            					case "10": scope = "(1~389)"; break;
            				}
            				eval_gr = grade + scope;
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_gr%>' readonly >
                    	<%	} else{
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_3.get("EVAL_GR")%>' readonly >
                    	<%	}
                    	%>
                    </td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=eval_3.get("EVAL_S_DT")%>' readonly ></td>
                </tr>
              <%	}
    		    }   %>
    		    
    		  <%}else{%>
    		  
    		  <%if(eval1_size > 0){
    		  		for(int i = 0 ; i < eval1_size ; i++){
    				Hashtable eval_1 = (Hashtable)evals_1.elementAt(i);%>	
                <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>����<input type='hidden' name='eval_gu' value='1'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_1.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_1.get("EVAL_OFF")).equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value='2' readonly <%if( (eval_1.get("EVAL_OFF")).equals("2")) out.println("selected");%>>NICE</option>
                          <option value='3' readonly <%if( (eval_1.get("EVAL_OFF")).equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                   	</td>
                    <td align="center"><input type='text' name='eval_score' size='12' class='text' value='<%=eval_1.get("EVAL_SCORE")%>' readonly ></td>
<%--                     <td align="center"><input type='text' name='eval_gr' size='12' class='text' value='<%=eval_1.get("EVAL_GR")%>' readonly ></td> --%>
                    <td align="center">
                    	<% if( String.valueOf(eval_1.get("EVAL_OFF")).equals("3")){
                    		String eval_gr = "";
                    		String scope = "";
                    		String grade = String.valueOf(eval_1.get("EVAL_GR"));
            				switch(grade){
            					case "1": scope = "(955~1000)"; break;
            					case "2": scope = "(907~954)"; break;
            					case "3": scope = "(837~906)"; break;
            					case "4": scope = "(770~836)"; break;
            					case "5": scope = "(693~769)"; break;
            					case "6": scope = "(620~692)"; break;
            					case "7": scope = "(535~619)"; break;
            					case "8": scope = "(475~534)"; break;
            					case "9": scope = "(390~474)"; break;
            					case "10": scope = "(1~389)"; break;
            				}
            				eval_gr = grade + scope;
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_gr%>' readonly >
                    	<%	} else{
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_1.get("EVAL_GR")%>' readonly >
                    	<%	}
                    	%>
                    </td>
    				<td align="center"><input type='text' name='eval_b_dt' size='11' class='text' value='<%=eval_1.get("EVAL_B_DT")%>' readonly></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=eval_1.get("EVAL_S_DT")%>' readonly ></td>
                </tr>
              <%	}
              	}	%>
              
              <%if(eval2_size > 0){
    		  		for(int i = 0 ; i < eval2_size ; i++){
    				Hashtable eval_2 = (Hashtable)evals_2.elementAt(i);%>		  
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%><input type='hidden' name='eval_gu' value='2'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_2.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_2.get("EVAL_OFF")).equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value='2' readonly <%if( (eval_2.get("EVAL_OFF")).equals("2")) out.println("selected");%>>NICE</option>
                          <option value='3' readonly <%if( (eval_2.get("EVAL_OFF")).equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><input type='text' name='eval_score' size='12' class='text' value='<%=eval_2.get("EVAL_SCORE")%>' readonly ></td>
<%--                     <td align="center"><input type='text' name='eval_gr' size='12' class='text' value='<%=eval_2.get("EVAL_GR")%>' readonly ></td> --%>
                    <td align="center">
                    	<% if( String.valueOf(eval_2.get("EVAL_OFF")).equals("3")){
                    		String eval_gr = "";
                    		String scope = "";
                    		String grade = String.valueOf(eval_2.get("EVAL_GR"));
            				switch(grade){
            					case "1": scope = "(955~1000)"; break;
            					case "2": scope = "(907~954)"; break;
            					case "3": scope = "(837~906)"; break;
            					case "4": scope = "(770~836)"; break;
            					case "5": scope = "(693~769)"; break;
            					case "6": scope = "(620~692)"; break;
            					case "7": scope = "(535~619)"; break;
            					case "8": scope = "(475~534)"; break;
            					case "9": scope = "(390~474)"; break;
            					case "10": scope = "(1~389)"; break;
            				}
            				eval_gr = grade + scope;
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_gr%>' readonly >
                    	<%	} else{
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_2.get("EVAL_GR")%>' readonly >
                    	<%	}
                    	%>
                    </td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=eval_2.get("EVAL_S_DT")%>' readonly ></td>
                </tr>
              <%	}
              	}	%>
                       
    		  <%}%>
    		  
    		  <%if(eval4_size > 0){
    		  		for(int i = 0 ; i < eval4_size ; i++){
    				Hashtable eval_4 = (Hashtable)evals_4.elementAt(i);%>		  
                <tr>
                    <td class=title>���뺸����<%=i+1%><input type='hidden' name='eval_gu' value='4'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_4.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_4.get("EVAL_OFF")).equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value='2' readonly <%if( (eval_4.get("EVAL_OFF")).equals("2")) out.println("selected");%>>NICE</option>
                          <option value='3' readonly <%if( (eval_4.get("EVAL_OFF")).equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><input type='text' name='eval_score' size='12' class='text' value='<%=eval_4.get("EVAL_SCORE")%>' readonly ></td>
<%--                     <td align="center"><input type='text' name='eval_gr' size='12' class='text' value='<%=eval_4.get("EVAL_GR")%>' readonly ></td> --%>
                    <td align="center">
                    	<% if( String.valueOf(eval_4.get("EVAL_OFF")).equals("3")){
                    		String eval_gr = "";
                    		String scope = "";
                    		String grade = String.valueOf(eval_4.get("EVAL_GR"));
            				switch(grade){
            					case "1": scope = "(955~1000)"; break;
            					case "2": scope = "(907~954)"; break;
            					case "3": scope = "(837~906)"; break;
            					case "4": scope = "(770~836)"; break;
            					case "5": scope = "(693~769)"; break;
            					case "6": scope = "(620~692)"; break;
            					case "7": scope = "(535~619)"; break;
            					case "8": scope = "(475~534)"; break;
            					case "9": scope = "(390~474)"; break;
            					case "10": scope = "(1~389)"; break;
            				}
            				eval_gr = grade + scope;
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_gr%>' readonly >
                    	<%	} else{
                    	%>
                    	<input type='text' name='eval_gr' size='12' class='text' value='<%=eval_4.get("EVAL_GR")%>' readonly >
                    	<%	}
                    	%>
                    </td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text'  value='<%=eval_4.get("EVAL_S_DT")%>' readonly ></td>
                </tr>
    		  <%	}
    		  	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڻ���Ȳ</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>����</td>
                    <td colspan="2" class=title>������1</td>
                    <td colspan="2" class=title>������2</td>
                </tr>
                <tr>
                    <td width="15%" class=title>����</td>
                    <td width="28%" class='title'>�ּ�</td>
                    <td width="15%" class=title>����</td>
                    <td width="29%" class='title'>�ּ�</td>
                </tr>
    		  <%if(client.getClient_st().equals("2")){%>
    		  
    		  <%if(eval3_size > 0){
    		  		for(int i = 0 ; i < eval3_size ; i++){
    				Hashtable eval_3 = (Hashtable)evals_3.elementAt(i);%>	
    		    <tr>
                    <td class=title>�����</td>
                    <td align="center"><input type='text' name='ass1_type' size='15' class='text' value='<%=eval_3.get("ASS1_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass1_zip"  size="7" class='text' value='<%=eval_3.get("ASS1_ZIP")%>' readonly > <input type='text' name='ass1_addr' size='25' class='text' value='<%=eval_3.get("ASS1_ADDR")%>' readonly ></td>
                    <td align="center"><input type='text' name='ass2_type' size='15' class='text' value='<%=eval_3.get("ASS2_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass2_zip"  size="7" class='text' value='<%=eval_3.get("ASS2_ZIP")%>' readonly > <input type='text' name='ass2_addr' size='25' class='text' value='<%=eval_3.get("ASS2_ADDR")%>' readonly ></td>
                </tr>
              <%	}
    		    }  %> 
                       
    		  <%}else{%>
    		  
    		  <%if(eval1_size > 0){
    		  		for(int i = 0 ; i < eval1_size ; i++){
    				Hashtable eval_1 = (Hashtable)evals_1.elementAt(i);%>	
    		    <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>����</td>
                    <td align="center"><input type='text' name='ass1_type' size='15' class='text' value='<%=eval_1.get("ASS1_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass1_zip"  size="7" class='text' value='<%=eval_1.get("ASS1_ZIP")%>' readonly > <input type='text' name='ass1_addr' size='25' class='text' value='<%=eval_1.get("ASS1_ADDR")%>' readonly ></td>
                    <td align="center"><input type='text' name='ass2_type' size='15' class='text' value='<%=eval_1.get("ASS2_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass2_zip"  size="7" class='text' value='<%=eval_1.get("ASS2_ZIP")%>' readonly > <input type='text' name='ass2_addr' size='25' class='text' value='<%=eval_1.get("ASS2_ADDR")%>' readonly ></td>
                </tr>
    		  <%	}
              	}	%>
              
              <%if(eval2_size > 0){
    		  		for(int i = 0 ; i < eval2_size ; i++){
    				Hashtable eval_2 = (Hashtable)evals_2.elementAt(i);%>          
          
          	    <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%></td>
                    <td align="center"><input type='text' name='ass1_type' size='15' class='text' value='<%=eval_2.get("ASS1_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass1_zip"  size="7" class='text' value='<%=eval_2.get("ASS1_ZIP")%>' readonly > <input type='text' name='ass1_addr' size='25' class='text' value='<%=eval_2.get("ASS1_ADDR")%>' readonly ></td>
                    <td align="center"><input type='text' name='ass2_type' size='15' class='text' value='<%=eval_2.get("ASS2_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass2_zip"  size="7" class='text' value='<%=eval_2.get("ASS2_ZIP")%>' readonly > <input type='text' name='ass2_addr' size='25' class='text' value='<%=eval_2.get("ASS2_ADDR")%>' readonly ></td>
                </tr>
              <%	}
              	}	%>
            
    		  <%}%>
    		  
    		  <%if(eval4_size > 0){
    		  		for(int i = 0 ; i < eval4_size ; i++){
    				Hashtable eval_4 = (Hashtable)evals_4.elementAt(i);%>	 	  
                <tr>
                    <td class=title>���뺸����<%=i+1%></td>
                    <td align="center"><input type='text' name='ass1_type' size='15' class='text' value='<%=eval_4.get("ASS1_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass1_zip"  size="7" class='text' value='<%=eval_4.get("ASS1_ZIP")%>' readonly > <input type='text' name='ass1_addr' size='25' class='text' value='<%=eval_4.get("ASS1_ADDR")%>' readonly ></td>
                    <td align="center"><input type='text' name='ass2_type' size='15' class='text' value='<%=eval_4.get("ASS2_TYPE")%>' readonly ></td>
                    <td align="center"><input type='text' name="ass2_zip"  size="7" class='text' value='<%=eval_4.get("ASS2_ZIP")%>' readonly > <input type='text' name='ass2_addr' size='25' class='text' value='<%=eval_4.get("ASS2_ADDR")%>' readonly ></td>
                </tr>
    		  <%	}
    		  	}%>		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
	<%if(client.getClient_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ҵ�����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>����</td>
                    <td width=20%>&nbsp;<%=client.getJob()%></td>
                    <td class=title width=10%>�ҵ汸��</td>
                    <td>&nbsp;
        			  <select name='pay_st' disabled>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>����</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>�޿��ҵ�</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>����ҵ�</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>��Ÿ����ҵ�</option>
        		            </select>
        			</td>			
                    <td class=title width=10%>���ҵ�</td>
                    <td>&nbsp;<%String pay_type = client.getPay_type();%><%if(pay_type.equals("1")){%>2000��������<%}else if(pay_type.equals("2")){%>2000~3000����<%}else if(pay_type.equals("3")){%>3000~4000����<%}else if(pay_type.equals("4")){%>4000�����̻�<%}%></td>
                </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;<%=client.getCom_nm()%></td>
                    <td class=title width=10%>�ټӿ���</td>
                    <td width=20%>&nbsp;<%=client.getWk_year()%>��</td>
                    <td class=title width=10%>����</td>
                    <td>&nbsp;<%=client.getTitle()%></td>
    		    </tr>		  		  
            </table>
        </td>
    </tr>
	<%}else{%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� �繫��ǥ</span></td>  <!--���� �ֱ��� �繫��ǥ ��ȸ�Ͽ� setting-->
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		            <td colspan="2" rowspan="2" class=title>����<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>���&nbsp;(  <%=c_fin.getC_kisu()%>  ��)</td>
		            <td width="43%" class=title>����&nbsp;(  <%=c_fin.getF_kisu()%>  ��)</td>
		        </tr>
		        <tr>
		            <td class=title>( <%=c_fin.getC_ba_year_s()%>&nbsp;~&nbsp;<%=c_fin.getC_ba_year()%> )</td>
		            <td class=title>( <%=c_fin.getF_ba_year_s()%>&nbsp;~&nbsp;<%=c_fin.getF_ba_year()%> )</td>
		        </tr>
		        <tr>   
		            <td colspan="2" class=title>�ڻ��Ѱ�</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_asset_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_asset_tot())+" �鸸��"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_asset_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_asset_tot())+" �鸸��"); %></td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>��<br>��</td>
		            <td width="9%" class=title>�ں���</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_cap() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_cap())+" �鸸��"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_cap() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_cap())+" �鸸��"); %></td>
		        </tr>
		        <tr>
		            <td class=title>�ں��Ѱ�</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_cap_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_cap_tot())+" �鸸��"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_cap_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_cap_tot())+" �鸸��"); %></td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>����</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_sale() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_sale())+" �鸸��"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_sale() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_sale())+" �鸸��"); %></td>
		        </tr>
		    </table>
        </td>
    </tr>
	<%}%>
	<tr>
	    <td colspan=4>&nbsp;</td>
	</tr>
	<tr>
	    <td colspan=4 align='right'><!--<a href='javascript:set_eval()' onMouseOver="window.status=''; return true"><img src="/images/confirm.gif" width="50" height="18" aligh="absmiddle" border="0"></a> &nbsp;&nbsp;-->
	    <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>
</table>
</body>
</html>