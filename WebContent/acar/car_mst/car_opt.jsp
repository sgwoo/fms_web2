<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");	
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");		
	String view_dt = request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();

	//차명정보
	cm_bean = a_cmd.getCarNmCase(car_id, car_seq);
	
	//기준일자
	Vector cars = a_cmd.getSearchCode(car_comp_id, car_cd, car_id, "", "9", "");
	int car_size = cars.size();
	
	//선택사양 리스트
	CarOptBean [] co_r = a_cmd.getCarOptList(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_id, cm_bean.getCar_seq(), view_dt);
		
	//동일차종 타모델 선택사양 - 현재 입력분 제외
	Vector vt = a_cmd.getCarOptRegList(car_comp_id, car_cd, view_dt);
	int vt_size = vt.size();
	
	//색상사양 잔가조정 리스트
	Vector vt2 = a_cmd.getCarShCodeBdtJgOptList(cm_bean.getJg_code(), "");
	int vt_size2 = vt2.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--
	//수정하기
	function Save(mode, idx){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		var ment;
		if(mode == 'u' || mode == 'd' || mode == 'i'){
			fm.h_car_s_seq.value 	= fm.car_s_seq[idx].value;
			fm.h_car_s.value 	= fm.car_s[idx].value;
			fm.h_car_s_p.value 	= fm.car_s_p[idx].value;
			fm.h_car_s_dt.value  	= fm.car_s_dt[idx].value;
			fm.h_use_yn.value  	= fm.use_yn[idx].value;	
			fm.h_opt_b.value 	= fm.opt_b[idx].value;
			fm.h_jg_opt_st.value	= fm.jg_opt_st[idx].value;
			fm.h_jg_tuix_st.value	= fm.jg_tuix_st[idx].value;
			fm.h_lkas_yn.value	= fm.lkas_yn[idx].value;
			fm.h_ldws_yn.value	= fm.ldws_yn[idx].value;
			fm.h_aeb_yn.value	= fm.aeb_yn[idx].value;
			fm.h_fcw_yn.value	= fm.fcw_yn[idx].value;
			fm.h_car_rank.value	= fm.car_rank[idx].value;
			fm.h_jg_opt_yn.value	= fm.jg_opt_yn[idx].value;
			fm.h_garnish_yn.value	= fm.garnish_yn[idx].value;			
			fm.h_hook_yn.value	= fm.hook_yn[idx].value;			
			
			if(mode == 'u'){
				ment = '수정';
			}else if(mode == 'd'){
				ment = '삭제';
			}else if(mode == 'i'){
				ment = '등록';
			}
			
			if(fm.h_car_s.value == ''){ 	alert('옵션명을 확인하십시오'); 	return; }
			if(fm.h_car_s_p.value == ''){ 	alert('옵션가격을 확인하십시오'); 	return; }
			if(fm.h_car_s_dt.value == ''){ 	alert('기준일자를 확인하십시오'); 	return; }		
			if(!max_length(fm.h_car_s.value, 1000)){ alert('기본사양이 영문1000자/한글500자를 초과하였습니다.\n\n확인하십시오'); return; }					
		}		
		
		if(!confirm(ment+'하시겠습니까?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}	
	
	//순서정렬 저장하기
	function Save_oderby(mode){
		var fm = document.form1;						
		if(!confirm('순서정렬을 저장하시겠습니까?')){	return;	}
		fm.mode.value = mode;
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}
	
	//전체수정하기
	function All_Save(){
		var fm = document.form1;						
		if(!confirm('전체수정하시겠습니까?')){	return;	}
		fm.mode.value = 'all';
		fm.action = 'car_opt_a.jsp';			
		fm.target = "i_no";
		fm.submit();
	}			
	
	function search(){
		var fm = document.form1;
		fm.target='popwin2';
		fm.action="car_opt.jsp";
		fm.submit();
	}
	
	function opt_set(idx){
		var fm = document.form1;
		var s_opt = fm.s_opt[idx].value;
		var ch_split = s_opt.split("||");	
		fm.car_s[idx].value 	= ch_split[0];
		if(ch_split[1] == undefined){
			fm.opt_b[idx].value 	= "";
		}else {
			fm.opt_b[idx].value 	= ch_split[1];	
		}
		fm.car_s_p[idx].value 	= parseDecimal(ch_split[2]);	
		fm.car_s_dt[idx].value 	= ch_split[3];	
		fm.jg_opt_st[idx].value = ch_split[4];	
		fm.jg_tuix_st[idx].value = ch_split[5];
		fm.jg_opt_yn[idx].value = ch_split[6];
		fm.lkas_yn[idx].value = ch_split[7];
		fm.ldws_yn[idx].value = ch_split[8];
		fm.aeb_yn[idx].value = ch_split[9];
		fm.fcw_yn[idx].value = ch_split[10];
		fm.hook_yn[idx].value = ch_split[11];
	}	
	
//-->
</script>
<script>
$(document).ready(function() {
	
	rankIndex();

	function rankIndex() {		
		var rank = $(".rank");
		var rankLen = $(".rank").length;
		
		for (var i = 0; i < rankLen; i++) {
			$(rank[i]).val(i+1);
		}
	}
	
	$('.rankUp').click(function() {
		var tr = $(this).closest('tr');
        tr.prev().before(tr);
        rankIndex();
    });
	
	$('.rankDown').click(function() {
		var tr = $(this).closest('tr');
		tr.next().after(tr);
		rankIndex();
    });
	
});
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.car_s<% if(co_r.length>0) %>[0]<%  %>.focus()">
<form action="./car_opt_a.jsp" name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">
	<input type="hidden" name="car_cd" value="<%=cm_bean.getCode()%>">
	<input type="hidden" name="car_id" value="<%=cm_bean.getCar_id()%>">
	<input type="hidden" name="car_seq" value="<%=cm_bean.getCar_seq()%>">
	<input type="hidden" name="car_nm" value="<%=car_nm%>">
	<input type="hidden" name="car_b_dt" value="<%=cm_bean.getCar_b_dt()%>">
	<input type="hidden" name="cmd" value="<%=cmd%>">
	<input type="hidden" name="size" value="<%=co_r.length%>">
	<input type="hidden" name="mode" value="">
	<input type="hidden" name="h_car_s_seq" value="">
	<input type="hidden" name="h_car_s" value="">
	<input type="hidden" name="h_car_s_p" value="">
	<input type="hidden" name="h_car_s_dt" value="">
	<input type="hidden" name="h_use_yn" value="">
	<input type="hidden" name="h_opt_b" value="">
	<input type="hidden" name="h_jg_opt_st" value="">
	<input type="hidden" name="h_jg_tuix_st" value="">
	<input type="hidden" name="h_lkas_yn" value="">
	<input type="hidden" name="h_ldws_yn" value="">
	<input type="hidden" name="h_aeb_yn" value="">
	<input type="hidden" name="h_fcw_yn" value="">
	<input type="hidden" name="h_car_rank" value="">
	<input type="hidden" name="h_jg_opt_yn" value="">
	<input type="hidden" name="h_garnish_yn" value="">
	<input type="hidden" name="h_hook_yn" value="">
	<input type="hidden" name="view_dt" value="<%=view_dt%>">
	<input type="hidden" name="s_opt_size" value="<%=vt_size%>">
	
	<table border=0 cellspacing=0 cellpadding=0 width="100%">
	    <tr>
	        <td>
	            <table border="0" cellspacing="0" cellpadding="0" width="100%">
	                <tr>
	                    <td>&nbsp;
	                      <img src=../images/center/arrow_cm.gif>&nbsp;&nbsp;<b>[ <%=car_nm%> ]</b> <%=cm_bean.getCar_name()%> <%=cm_bean.getJg_code()%>&nbsp;&nbsp;
	                      <img src=../images/center/arrow_gjij.gif>&nbsp; 
	                      <%=AddUtil.ChangeDate2(view_dt)%>	                      
	                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class=h></td>
	    </tr>
	    <tr>
	        <td align="right">
	        <%if(!auth_rw.equals("1")){%>
		        <a href="javascript:Save_oderby('ob')">[순서정렬 저장]</a>
		        <a href="javascript:All_Save()">[일괄처리]</a>
		        &nbsp;&nbsp;
	        <%}%>
	        	<a href="javascript:self.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a>
	        </td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
	    <tr>
	        <td class=line>
	            <table border="0" cellspacing="1" cellpadding="0" width="100%">
	            	<thead>
		                <tr>
		                    <td class=title style="display: none;">연번</td>
		                    <td class=title width="10%">선택사양품목</td>
		                    <td class=title width="10%">세부내용</td>
		                    <td class=title width="6%">조정잔가</td>
		                    <td class=title width="6%">순서</td>
		                    <td class=title width="4%"><span style="font-size:85%">TUIX/TUON<br>옵션여부</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">잔가반영<br>여부</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">차선이탈<br>제어형</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">차선이탈<br>경고형</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">긴급제동<br>제어형</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">긴급제동<br>경고형</span></td>
		                    <td class=title width="4%"><span style="font-size:85%">가니쉬 여부</span></td>
		                    <td class=title width="6%"><span style="font-size:85%">견인고리<br>(트레일러용)</span></td>
		                    <td class=title width="12%">금액</td>
		                    <td class=title width="10%">기준일자</td>
		                    <td class=title width="5%">사용<br>여부</td>
		                    <td class=title width="5%">처리</td>
		                </tr>
	                </thead>
	                <tbody>
	              <%	for(int i=0; i<co_r.length; i++){
	    			        co_bean = co_r[i];%>
		                <tr> 
		                    <td align="center"  style="display: none;">
		                    	<%=i+1%>
		                    	<input type="hidden" name="car_s_seq" value="<%=co_bean.getCar_s_seq()%>">
		    					<input type="hidden" name="s_opt" value="">
		                    </td>
		                    <td align="center">
		                    	<textarea cols="28" rows="4" name="car_s"><%=co_bean.getCar_s()%></textarea>
		                    </td>
		                    <td align="center">
		                    	<textarea cols="28" rows="4" name="opt_b"><%=co_bean.getOpt_b()%></textarea>
		                    </td>
		                    <td align="center">
		                      	<select name="jg_opt_st">
			                        <option value="" selected>선택</option>
		                       		<%for(int j = 0 ; j < vt_size2 ; j++){
		       							Hashtable ht = (Hashtable)vt2.elementAt(j);%>
					        		<option value="<%=ht.get("JG_OPT_ST")%>" <% if(co_bean.getJg_opt_st().equals(String.valueOf(ht.get("JG_OPT_ST")))) out.print("selected"); %>>[<%=ht.get("JG_OPT_ST")%>]<%=ht.get("JG_OPT_1")%></option>
									<%}%>
				      			</select>
				      			<input type="hidden" class="rank" name="car_rank" value="">
		                    </td>
		                    <td align="center">
		                    	<button type="button" class="rankUp" onmouseover="this.style.cursor='pointer'" style="border: 0px; background-color: #FFFFFF; width: 39px; height: 17px; padding: 0px; margin-bottom:7px;"><img src=../images/center/button_in_up.png border=0></button><br/> <!-- onclick="moveUp(this)" -->
		                    	<button type="button" class="rankDown" onmouseover="this.style.cursor='pointer'" style="border: 0px; background-color: #FFFFFF; width: 50px; height: 17px; padding: 0px;"><img src=../images/center/button_in_down.png border=0></button> <!-- onclick="moveDown(this)" -->
		                    </td>
		                    <td align="center">
		                    	<select name="jg_tuix_st" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getJg_tuix_st().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getJg_tuix_st().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getJg_tuix_st().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<select name="jg_opt_yn" style="size:3.5em;">
		        					<option value="" <% if(co_bean.getJg_opt_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="Y" <% if(co_bean.getJg_opt_yn().equals("Y")) out.print("selected"); %>>잔가반영</option>
		        					<option value="N" <% if(co_bean.getJg_opt_yn().equals("N")) out.print("selected"); %>>잔가미반영</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="lkas_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getLkas_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getLkas_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getLkas_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="ldws_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getLdws_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getLdws_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getLdws_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="aeb_yn" style="size:3.5em;">
		            				<option value=""  <% if(co_bean.getAeb_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getAeb_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getAeb_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="fcw_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getFcw_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getFcw_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getFcw_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td>
		                    	<select name="garnish_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getGarnish_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getGarnish_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getGarnish_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<select name="hook_yn" style="size:3.5em;">
		           					<option value=""  <% if(co_bean.getHook_yn().equals(""))  out.print("selected"); %>>선택</option>
		        					<option value="N" <% if(co_bean.getHook_yn().equals("N")) out.print("selected"); %>>미해당</option>
		        					<option value="Y" <% if(co_bean.getHook_yn().equals("Y")) out.print("selected"); %>>해당</option>
				      			</select>
		                    </td>
		                    <td align="center">
		                    	<input type="text" name="car_s_p" value="<%=AddUtil.parseDecimal(co_bean.getCar_s_p())%>" size="7" class=num>원</td>
		                    <td align="center">
		                    	<input type="text" name="car_s_dt" value="<%=AddUtil.ChangeDate2(co_bean.getCar_s_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		                    </td>
		                    <td align="center">
		                    	<select name="use_yn">
				        			<option value="Y" <% if(co_bean.getUse_yn().equals("Y")) out.print("selected"); %>>Y</option>
				        			<option value="N" <% if(co_bean.getUse_yn().equals("N")) out.print("selected"); %>>N</option>
						    	</select>
		                    </td>
		                    <td align="center">
		                    <%if(!auth_rw.equals("1")){%>
			                    <a href="javascript:Save('u', '<%=i%>')">
			                    	<img src=../images/center/button_in_modify.gif border=0 align=absmiddle style="margin-bottom:7px">
			                    </a><br>
			                    <a href="javascript:Save('d', '<%=i%>')">
			                    	<img src=../images/center/button_in_delete.gif border=0 align=absmiddle>
			                    </a>
		                    <%}%>
		                    </td>
		                </tr>
	              <%	}	%>
	              	</tbody>
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
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<!--추가-->
				<%	for(int i=co_r.length; i<(co_r.length+5); i++){%>
					<tr>
	                    <td rowspan="2" width="3%" align="center">
	                    	<span style="font-size:85%">추가</span>
	                    	<input type="hidden" name="car_s_seq" value="">
	                    	<input type="hidden" class="rank" name="car_rank" value="">
	                    </td>
	                    <td colspan="13" width="89%" align="center">
	                    	<select name="s_opt" onChange="javascript:opt_set(<%=i%>)">
								<option value="" selected>선택</option>
	                       		<%for(int j = 0 ; j < vt_size ; j++){
	        						Hashtable ht = (Hashtable)vt.elementAt(j);%>
								<option value="<%=ht.get("CAR_S")%>||<%=ht.get("OPT_B")%>||<%=ht.get("CAR_S_P")%>||<%=ht.get("E_DT")%>||<%=ht.get("JG_OPT_ST")%>||<%=ht.get("JG_TUIX_ST")%>||<%=ht.get("JG_OPT_YN")%>||<%=ht.get("LKAS_YN")%>||<%=ht.get("LDWS_YN")%>||<%=ht.get("AEB_YN")%>||<%=ht.get("FCW_YN")%>||<%=ht.get("HOOK_YN")%>">[<%=ht.get("E_DT")%>]<%=ht.get("CAR_S")%>-<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_S_P")))%></option>
								<%}%>
							</select>
	                    </td>
						<td rowspan="2"  width="4%" align="center"><!-- 사용여부 -->
							<select name="use_yn">
								<option value="Y" selected>Y</option>
								<option value="N">N</option>
							</select>
	                    </td>
	                    <td rowspan="2"  width="4%" align="center"><!-- 등록 -->
	                    <%if(!auth_rw.equals("1")){%>
	                    	<a href="javascript:Save('i', '<%=i%>')">
	                    		<img src=../images/center/button_in_reg.gif border=0 align=absmiddle>
	                    	</a>
	                    <%}%>
	                    </td>
	                </tr>
	                <tr>
		                <td align="center" width="16%"><!-- 선택사양품목 -->
		                	<textarea cols="28" rows="4" name="car_s"></textarea>
		                </td>
		                <td align="center" width="16%"><!-- 세부내용 -->
		                	<textarea cols="28" rows="4" name="opt_b"></textarea>
		                </td>
		                <td align="center" width="9%"><!-- 조정잔가 --> 
							<select name="jg_opt_st">
		                      	<option value="" selected>선택</option>
	                      		<%for(int j = 0 ; j < vt_size2 ; j++){
			      					Hashtable ht = (Hashtable)vt2.elementAt(j);%>
			      				<option value="<%=ht.get("JG_OPT_ST")%>">[<%=ht.get("JG_OPT_ST")%>]<%=ht.get("JG_OPT_1")%></option>
								<%}%>
							</select>
	                  	</td>
	                  	<td align="center" width="4%"><!-- TUIX/TUON 옵션품목 -->
	                  		<select name="jg_tuix_st" style="size:3.5em;">
			                   	<option value="" >선택</option>
			       				<option value="N" >미해당</option>
			       				<option value="Y" >해당</option>
			      			</select>
						</td>
		                <td align="center" width="4%"><!-- TUIX/TUON 잔가반영여부 -->
		                  	<select name="jg_opt_yn" style="size:3.5em;">
		          				<option value="">선택</option>
		      					<option value="Y">잔가반영</option>
		      					<option value="N">잔가미반영</option>
		      				</select>
		                </td>
		                <td align="center" width="4%"><!-- 차선이탈 제어형 -->
		                	<select name="lkas_yn" style="size:3.5em;">
			                   	<option value="" >선택</option>
			        			<option value="N" >미해당</option>
				        		<option value="Y" >해당</option>
				     		</select>
		                </td>
		                <td align="center" width="4%"><!-- 차선이탈 경고형 -->
		                	<select name="ldws_yn" style="size:3.5em;">
			                  	<option value="" >선택</option>
				        		<option value="N" >미해당</option>
				        		<option value="Y" >해당</option>
			      			</select>
		                </td>
		                <td align="center" width="4%"><!-- 긴급제동 제어형 -->
		                	<select name="aeb_yn" style="size:3.5em;">
			                   	<option value="" >선택</option>
				        		<option value="N" >미해당</option>
				        		<option value="Y" >해당</option>
			      			</select>
		                </td>
		                <td align="center" width="4%"><!-- 긴급제동 경고형 -->
							<select name="fcw_yn" style="size:3.5em;">
		                    	<option value="" >선택</option>
			        			<option value="N" >미해당</option>
			        			<option value="Y" >해당</option>
				      		</select>
		                </td>
		                <td align="center" width="4%"><!-- 가니쉬여부 -->
							<select name="garnish_yn" style="size:3.5em;">
		                    	<option value="" >선택</option>
			        			<option value="N" >미해당</option>
			        			<option value="Y" >해당</option>
				      		</select>
		                </td>
		                <td align="center" width="6%"><!-- 견인고리 -->
							<select name="hook_yn" style="size:3.5em;">
		                    	<option value="" >선택</option>
			        			<option value="N" >미해당</option>
			        			<option value="Y" >해당</option>
				      		</select>
		                </td>
		                <td align="center" width="9%"><!-- 금액 -->
		                    <input type="text" name="car_s_p" value="" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>원
		                </td>
		                <td align="center" width="9%"><!-- 기준일자 -->
		                    <input type="text" name="car_s_dt" size="11" value="<%= AddUtil.getDate() %>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		                </td>
	                </tr>
	                <%}%>
	              
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class=h></td>
	    </tr>
	    <tr>
	        <td align="right">
	        <%if(!auth_rw.equals("1")){%>
		        <a href="javascript:All_Save()">[일괄처리]</a>
		        &nbsp;&nbsp;
	        <%}%>
		        <a href="javascript:self.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a>
	        </td>
	    </tr>
	</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>
