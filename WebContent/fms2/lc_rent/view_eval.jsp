<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//거채처 최근 계약 정보
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	ContBaseBean base1 = a_db.getRecentCont(client_id);
	
	if(rent_mng_id.equals(""))	rent_mng_id = base1.getRent_mng_id();
	if(rent_l_cd.equals(""))	rent_l_cd 	= base1.getRent_l_cd();
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//신용평가정보 - 법인
	Vector evals_1  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "1" );
	int eval1_size = evals_1.size();
	
	//신용평가정보 - 대표이사
	Vector evals_2  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "2" );
 	int eval2_size = evals_2.size();
 
	//신용평가정보 - 개인
	Vector evals_3  = a_db.getContEvalList(rent_mng_id, rent_l_cd, "3" );
	int eval3_size = evals_3.size();
	
	//신용평가정보 - 보증인
	Vector evals_4  = a_db.getContEvalList(rent_mng_id, rent_l_cd , "4" );
	int eval4_size = evals_4.size();
	
	//고객재무제표
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
						//법인   	
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
						//대표이사   	
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
				
						//계약자   	
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
							//보증인   	
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
							//보증인   	
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
		
			alert ("최근 데이타가 없습니다. 자료를 복사할 수 없습니다.!! 자료를 입력하세요.!!");
				
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>신용평가보기</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용사항</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="13%" class=title>구분</td>
                  <td width="16%" class=title>상호/성명</td>
                  <td width="12%" class=title>판정기관</td>
                  <td width="13%" class=title>신용평점</td>
                  <td width="16%" class='title'>신용등급</td>
                  <td width="16%" class='title'>평가(산출)일자</td>					
                  <td width="16%" class='title'>조회일자</td>
                </tr>
              <%if(client.getClient_st().equals("2")){%>
              
              <%if(eval3_size > 0){
    		  		for(int i = 0 ; i < eval3_size ; i++){
    				Hashtable eval_3 = (Hashtable)evals_3.elementAt(i);%>	
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='3'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_3.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                         <option value='1' readonly <%if( (eval_3.get("EVAL_OFF")).equals("1")) out.println("selected");%>>크레탑</option>
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
                    <td class=title>법인<input type='hidden' name='eval_gu' value='1'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_1.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_1.get("EVAL_OFF")).equals("1")) out.println("selected");%>>크레탑</option>
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
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='2'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_2.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_2.get("EVAL_OFF")).equals("1")) out.println("selected");%>>크레탑</option>
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
                    <td class=title>연대보증인<%=i+1%><input type='hidden' name='eval_gu' value='4'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='text' value='<%=eval_4.get("EVAL_NM")%>' readonly ></td>
                    <td align="center" >
                      <select name='eval_off'>
                          <option value='1' readonly <%if( (eval_4.get("EVAL_OFF")).equals("1")) out.println("selected");%>>크레탑</option>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자산현황</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>구분</td>
                    <td colspan="2" class=title>물건지1</td>
                    <td colspan="2" class=title>물건지2</td>
                </tr>
                <tr>
                    <td width="15%" class=title>형태</td>
                    <td width="28%" class='title'>주소</td>
                    <td width="15%" class=title>형태</td>
                    <td width="29%" class='title'>주소</td>
                </tr>
    		  <%if(client.getClient_st().equals("2")){%>
    		  
    		  <%if(eval3_size > 0){
    		  		for(int i = 0 ; i < eval3_size ; i++){
    				Hashtable eval_3 = (Hashtable)evals_3.elementAt(i);%>	
    		    <tr>
                    <td class=title>계약자</td>
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
                    <td class=title>법인</td>
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
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
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
                    <td class=title>연대보증인<%=i+1%></td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>소득정보</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>직업</td>
                    <td width=20%>&nbsp;<%=client.getJob()%></td>
                    <td class=title width=10%>소득구분</td>
                    <td>&nbsp;
        			  <select name='pay_st' disabled>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>선택</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>급여소득</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>사업소득</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>기타사업소득</option>
        		            </select>
        			</td>			
                    <td class=title width=10%>연소득</td>
                    <td>&nbsp;<%String pay_type = client.getPay_type();%><%if(pay_type.equals("1")){%>2000만원이하<%}else if(pay_type.equals("2")){%>2000~3000만원<%}else if(pay_type.equals("3")){%>3000~4000만원<%}else if(pay_type.equals("4")){%>4000만원이상<%}%></td>
                </tr>
    		    <tr>
        		    <td class='title'>직장명</td>
        		    <td>&nbsp;<%=client.getCom_nm()%></td>
                    <td class=title width=10%>근속연수</td>
                    <td width=20%>&nbsp;<%=client.getWk_year()%>년</td>
                    <td class=title width=10%>직위</td>
                    <td>&nbsp;<%=client.getTitle()%></td>
    		    </tr>		  		  
            </table>
        </td>
    </tr>
	<%}else{%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>요약 재무제표</span></td>  <!--가장 최근의 재무제표 조회하여 setting-->
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		            <td colspan="2" rowspan="2" class=title>구분<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>당기&nbsp;(  <%=c_fin.getC_kisu()%>  기)</td>
		            <td width="43%" class=title>전기&nbsp;(  <%=c_fin.getF_kisu()%>  기)</td>
		        </tr>
		        <tr>
		            <td class=title>( <%=c_fin.getC_ba_year_s()%>&nbsp;~&nbsp;<%=c_fin.getC_ba_year()%> )</td>
		            <td class=title>( <%=c_fin.getF_ba_year_s()%>&nbsp;~&nbsp;<%=c_fin.getF_ba_year()%> )</td>
		        </tr>
		        <tr>   
		            <td colspan="2" class=title>자산총계</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_asset_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_asset_tot())+" 백만원"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_asset_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_asset_tot())+" 백만원"); %></td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>자<br>본</td>
		            <td width="9%" class=title>자본금</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_cap() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_cap())+" 백만원"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_cap() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_cap())+" 백만원"); %></td>
		        </tr>
		        <tr>
		            <td class=title>자본총계</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_cap_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_cap_tot())+" 백만원"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_cap_tot() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_cap_tot())+" 백만원"); %></td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>매출</td>
		            <td align="center">&nbsp;<%if(c_fin.getC_sale() > 0) out.println(AddUtil.parseDecimal(c_fin.getC_sale())+" 백만원"); %></td>
		            <td align="center">&nbsp;<%if(c_fin.getF_sale() > 0) out.println(AddUtil.parseDecimal(c_fin.getF_sale())+" 백만원"); %></td>
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