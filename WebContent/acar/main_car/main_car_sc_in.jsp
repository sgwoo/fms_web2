<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//주요차종 월대여료 리스트 페이지
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();


	Vector vt = ej_db.getJuyoCars_201905(car_comp_id, t_wd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function main_car_upd(est_id, base_dt, car_comp_id, cng_st, diesel_yn){
		parent.parent.location.href = "./main_car_upd_20090901.jsp?est_id="+est_id+"&base_dt="+base_dt+"&car_comp_id="+car_comp_id+"&t_wd=<%=t_wd%>&cng_st="+cng_st+"&diesel_yn="+diesel_yn;		
	}
	
	function main_car_upd_h(action_st, est_id, base_dt, car_comp_id, cng_st, diesel_yn){
		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
		var SUBWIN="./main_car_upd_20090901.jsp?action_st="+action_st+"&est_id="+est_id+"&base_dt="+base_dt+"&car_comp_id="+car_comp_id+"&t_wd=<%=t_wd%>&cng_st="+cng_st+"&diesel_yn="+diesel_yn;
		window.open(SUBWIN, "JuyoEsti", "left=0, top=0, width=5, height=5, scrollbars=yes, status=yes, resizeable=yes");	
		<%}else{%>
		return;
		<%}%>
	}
	
	//프로시저호출
	function main_car_upd_h_sp(est_tel){
		var SUBWIN="/acar/main_car_hp/sp_esti_reg_hp_case.jsp?est_tel="+est_tel;
		window.open(SUBWIN, "SP_JuyoEsti", "left=0, top=0, width=5, height=5, scrollbars=yes, status=yes, resizeable=yes");	
	}	
	
	function main_car_upd_h_r(action_st, est_id, base_dt, car_comp_id, cng_st, diesel_yn, idx){
		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
		var SUBWIN="./main_car_upd_20090901.jsp?action_st="+action_st+"&est_id="+est_id+"&base_dt="+base_dt+"&car_comp_id="+car_comp_id+"&t_wd=<%=t_wd%>&cng_st="+cng_st+"&diesel_yn="+diesel_yn;
		window.open(SUBWIN, "JuyoEsti", "left="+idx+", top="+idx+", width=5, height=5, scrollbars=yes, status=yes, resizeable=yes");	
		<%}else{%>
		return;
		<%}%>
	}	
		
	//비용비교보기
	function go_esti_print(est_id, diesel_yn, print_type){  
		var fm = document.form1;
		var SUBWIN = '';
		if(print_type == '6'){
			SUBWIN="/acar/main_car_hp/estimate_eh_all.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>";
			window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=760, height=700, scrollbars=yes, status=yes");
		}else{
			SUBWIN="/acar/main_car_hp/estimate.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>";		
			window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");
		}
	}	
	
	function go_esti_sik_view(reg_code){
		var fm = document.form1;
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?reg_code="+reg_code+"&esti_table=estimate_hp";
		window.open(SUBWIN, "EstiSikView", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resizable=yes");	
	}
	

//-->
</script>
</head>
<body style="margin: 0px;">
<form action="../estimate_mng/esti_mng_u.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">  
  <input type="hidden" name="base_dt" value="<%=base_dt%>">  
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">      
  <input type="hidden" name="t_wd" value="<%=t_wd%>">      
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line" width=100%>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
    		<% if(vt.size()>0){
    			for(int i=0; i<vt.size(); i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				int rb36_amt = AddUtil.parseInt((String)ht.get("RB36_AMT"));
    				int rs36_amt = AddUtil.parseInt((String)ht.get("RS36_AMT"));
    				int lb36_amt = AddUtil.parseInt((String)ht.get("LB36_AMT"));
    				int ls36_amt = AddUtil.parseInt((String)ht.get("LS36_AMT"));
    				int lb36_amt2 = AddUtil.parseInt((String)ht.get("LB36_AMT2"));
    				int ls36_amt2 = AddUtil.parseInt((String)ht.get("LS36_AMT2"));
    				String auto_yn = (String)ht.get("AUTO_YN");
    				String diesel_yn = (String)ht.get("DIESEL_YN"); 
    				String opt = (String)ht.get("OPT");
    				String car_b = (String)ht.get("CAR_B");
    				%>
                <tr> 
                    <td width=3%><div align="center"><%= i+1 %></div></td>
                    <td width='3%' align='center'>
			<input type="checkbox" name="ch_l_cd" value="<%= ht.get("SEQ") %>">			
		    </td>	                    
                    <td width=4%><div align="center"><%= ht.get("SEQ") %><br><br><%= ht.get("EST_FAX") %></div></td>
                    <td width=12%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <a href="javascript:main_car_upd('<%= ht.get("EST_ID") %>','<%= base_dt %>','<%= car_comp_id %>','<%= ht.get("CNG_ST") %>','<%= ht.get("DIESEL_YN") %>')"><%= ht.get("CAR_NM") %> <%= ht.get("CAR_NAME") %></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=4%><div align="center"><%   if(auto_yn.equals("Y")){ 
														out.print("오토"); 
													}else{ 
														if(opt.indexOf("변속") != -1 || opt.indexOf("DCT") != -1 || opt.indexOf("A/T") != -1 || opt.indexOf("C-TECH") != -1 || car_b.indexOf("무단 변속") != -1){
															out.print("오토"); 
														}else{
															out.print("수동"); 
														}
													} 
													%><br>
													<font color="#CCCCCC"><%= ht.get("SPR_YN") %></font>
													</div></td>
                    <td width=5%><div align="center"><% if(diesel_yn.equals("Y")){
		  											out.print("디젤"); 
		  										}else if(diesel_yn.equals("1")||diesel_yn.equals("0")){
													out.print("휘발유");
												}else if(diesel_yn.equals("2")){
													out.print("LPG");
												}else if(diesel_yn.equals("3")){
													out.print("휘발유");
												}else if(diesel_yn.equals("4")){
													out.print("전기+휘발유");
												}else if(diesel_yn.equals("5")){
													out.print("전기");
												}else if(diesel_yn.equals("6")){
													out.print("수소");	
												} %></div></td>
                    <td width=6%><div align="right"><%= AddUtil.parseDecimal((String)ht.get("O_1")) %></div></td>
                    <td width=5%><div align="right"><%= AddUtil.parseDecimal((String)ht.get("DC_AMT")) %>
                      <%if(AddUtil.parseInt((String)ht.get("DC_AMT"))>0){%>
                      <br><%= ht.get("DC") %>
                      <%}%>
                    </td>
                    <td width=3% align="center"><%= ht.get("JG_A") %><br><%= ht.get("JG_CODE") %><%//= ht.get("JG_T") %><%//= ht.get("CNG_ST") %></td>			
                    <td width=3% align="center"><%= ht.get("USE_YN") %><br><font color=red><%= ht.get("CNG_ST") %></font></td>
                    <td width=3%><div align="center">36</div></td>
                    
                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">            
                                <% if(rb36_amt>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("RB36_ID") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(rb36_amt) %></a>
                    			<br><a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("RB36_ID")), 10) %></font></a>
                    			<%if(!String.valueOf(ht.get("RB36_AMT")).equals(String.valueOf(ht.get("MC_RB36_AMT")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_RB36_AMT"))-AddUtil.parseInt((String)ht.get("RB36_AMT"))%></font>
                    			<%}%>
                                <% }else if(rb36_amt==0){ %>
                                미운영 
                                <% }else if(rb36_amt<0){ %>
                                이용불가 
                                <% } %>
                    			</div></td> 
                    	    </tr>
                    	</table>
                    </td>
                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">
                                <% if(rs36_amt>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("RS36_ID") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(rs36_amt) %></a>
                    			<br><a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("RS36_ID")), 10)%></font></a>
                    			<%if(!String.valueOf(ht.get("RS36_AMT")).equals(String.valueOf(ht.get("MC_RS36_AMT")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_RS36_AMT"))-AddUtil.parseInt((String)ht.get("RS36_AMT"))%></font>
                    			<%}%>
                                <% }else if(rs36_amt==0){ %>
                                미운영 
                                <% }else if(rs36_amt<0){ %>
                                이용불가 
                                <% } %></div></td> 
                            </tr>
                        </table>
                    </td>                                       

                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">
                                <% if(lb36_amt>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("LB36_ID") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(lb36_amt) %></a>
                    			<br>
                    			<a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("LB36_ID")), 10) %></font></a>
                    			<%if(!String.valueOf(ht.get("LB36_AMT")).equals(String.valueOf(ht.get("MC_LB36_AMT")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_LB36_AMT"))-AddUtil.parseInt((String)ht.get("LB36_AMT"))%></font>
                    			<%}%>
                                <% }else if(lb36_amt==0){ %>
                                미운영 
                                <% }else if(lb36_amt<0){ %>
                                이용불가 
                                <% } %></div></td> 
                            </tr>
                        </table>
                    </td>
                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">
                                <% if(ls36_amt>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("LS36_ID") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(ls36_amt) %></a>
                    			<br><a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("LS36_ID")), 10) %></font></a>
                    			<%if(!String.valueOf(ht.get("LS36_AMT")).equals(String.valueOf(ht.get("MC_LS36_AMT")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_LS36_AMT"))-AddUtil.parseInt((String)ht.get("LS36_AMT"))%></font>
                    			<%}%>
                                <% }else if(ls36_amt==0){ %>
                                미운영 
                                <% }else if(ls36_amt<0){ %>
                                이용불가 
                                <% } %></div></td> 
                            </tr>
                        </table>
                    </td>
					
                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">
                                <% if(lb36_amt2>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("LB36_ID2") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(lb36_amt2) %></a>
                    			<br>
                    			<a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("LB36_ID2")), 10) %></font></a>
                    			<%if(!String.valueOf(ht.get("LB36_AMT2")).equals(String.valueOf(ht.get("MC_LB36_AMT2")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_LB36_AMT2"))-AddUtil.parseInt((String)ht.get("LB36_AMT2"))%></font>
                    			<%}%>
                                <% }else if(lb36_amt2==0){ %>
                                미운영 
                                <% }else if(lb36_amt2<0){ %>
                                이용불가 
                                <% } %></div></td> 
                            </tr>
                        </table>
                    </td>
                    <td width=7%>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                <div align="center">
                                <% if(ls36_amt2>0){ %>
                                	<a href="javascript:go_esti_print('<%= ht.get("LS36_ID2") %>','<%=diesel_yn%>','<%= ht.get("PRINT_TYPE") %>');" onMouseOver="window.status=''; return true"><%= AddUtil.parseDecimal(ls36_amt2) %></a>
                    			<br>
                    			<a href="javascript:go_esti_sik_view('<%= ht.get("REG_CODE") %>');"><font color=#CCCCCC><%= Util.subData(String.valueOf(ht.get("LS36_ID2")), 10) %></font></a>
                    			<%if(!String.valueOf(ht.get("LS36_AMT2")).equals(String.valueOf(ht.get("MC_LS36_AMT2")))){%>
                    				<br>
                    				<font color=red><%=AddUtil.parseInt((String)ht.get("MC_LS36_AMT2"))-AddUtil.parseInt((String)ht.get("LS36_AMT2"))%></font>
                    			<%}%>
                                <% }else if(ls36_amt2==0){ %>
                                미운영 
                                <% }else if(ls36_amt2<0){ %>
                                이용불가 
                                <% } %></div></td> 
                            </tr>
                        </table>
                    </td>
                    					
                    <td width=7% align="center">
					<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
					<span class="b"><a href="javascript:main_car_upd_h('h_a', '<%= ht.get("EST_ID") %>','<%= base_dt %>','<%= car_comp_id %>','<%= ht.get("CNG_ST") %>','<%= ht.get("DIESEL_YN") %>')" title='FMS 주요차종 견적하기'><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span><br>
					<!--<br>
					<span class="b"><a href="javascript:main_car_upd_h_sp('<%= ht.get("SEQ") %>')" title='한차종만 프로시저호출하여 견적'><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span><br>					
					-->
					<%}%>
					<%if(String.valueOf(ht.get("RENT_DT_ST")).equals("Y")){%><font color=red><%}%>
					<%= AddUtil.ChangeDate5(String.valueOf(ht.get("REG_DT"))) %>
					<%if(String.valueOf(ht.get("RENT_DT_ST")).equals("Y")){%></font><%}%>					
					</td>
                </tr>
		<%	}
		 }else{ %>
                <tr> 
                    <td colspan="16"><div align="center">해당 데이터가 없습니다.</div></td>
                </tr>
		<% } %>
            </table>
        </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--
	function main_car_upd_all_h(){
		var speed = 0;
		var add_speed = 10000;//add_speed/1000초
	
		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    	<%	 if(vt.size()>0){
    			for(int i=0; i<vt.size(); i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		setTimeout("main_car_upd_h(<%if(i+1<vt.size()){%>'h',<%}else{%>'h_a',<%}%> '<%= ht.get("EST_ID") %>', '<%= base_dt %>','<%= car_comp_id %>', '<%= ht.get("CNG_ST") %>', '<%= ht.get("DIESEL_YN") %>')", speed);
		speed+=add_speed;
		<%		}
			}%>
		<%}else{%>
		return;
		<%}%>
	}
	
	function main_car_upd_all_h_r(){
		var speed = 0;
		var add_speed = 2000;//add_speed/1000초
	
		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    	<%	 if(vt.size()>0){
    			for(int i=0; i<vt.size(); i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		setTimeout("main_car_upd_h_r(<%if(i+1<vt.size()){%>'r',<%}else{%>'r_a',<%}%> '<%= ht.get("EST_ID") %>', '<%= base_dt %>','<%= car_comp_id %>', '<%= ht.get("CNG_ST") %>', '<%= ht.get("DIESEL_YN") %>',<%=i%>)", speed);
		speed+=add_speed;
		<%		}
			}%>
		<%}else{%>
		return;
		<%}%>
	}	
//-->
</script>
</body>
</html>
