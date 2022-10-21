<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*,acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//고객재무제표-최근등록건
	ClientFinBean c_fin = new ClientFinBean();
	
	//계약기타정보-최근평가내용
	ContEtcBean max_cont_etc = new ContEtcBean();


	if(!base.getClient_id().equals("000228")){
		Vector fin_vt = al_db.getClientFinList(base.getClient_id());
		int fin_vt_size = fin_vt.size();
		for(int i = 0 ; i < fin_vt_size ; i++){
			ClientFinBean fin = (ClientFinBean)fin_vt.elementAt(i);			
			if((i+1) == fin_vt_size){
				c_fin = fin;
			}
		}		
		max_cont_etc = a_db.getContEtc(base.getClient_id());
	}
	
	
	//고객별 최근등록 신용평가 조회
	ContEvalBean eval1 = new ContEvalBean();
	ContEvalBean eval2 = new ContEvalBean();
	ContEvalBean eval3 = new ContEvalBean();
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = new ContEvalBean();
	ContEvalBean eval6 = new ContEvalBean();
	ContEvalBean eval7 = new ContEvalBean();
	ContEvalBean eval8 = new ContEvalBean();
	
	
	
	
	//신용등급코드
	CodeBean[] gr_cd1 = c_db.getCodeAll2("0013", "1");
	CodeBean[] gr_cd2 = c_db.getCodeAll2("0013", "2");
	CodeBean[] gr_cd3 = c_db.getCodeAll2("0013", "3");
	
	int eval_cnt = 0;
	
	//자산형태
	CodeBean[] ass_cd = c_db.getCodeAll2("0014", "");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step3.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//판정기관별 신용등급 디스플레이
	function SetEval_gr(idx){
		var fm = document.form1;
		
		var gr_size = toInt(fm.eval_cnt.value);	
		
	 	
		
		if(gr_size > 1){
		
			if(fm.eval_off[idx].value == '2' || fm.eval_off[idx].value == '3'){		
				fm.eval_gr[idx].length = <%= gr_cd1.length+1 %>;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '선택';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off[idx].value == '1'){		
				if(fm.eval_gu[idx].value == '1'){
					fm.eval_gr[idx].length = <%= gr_cd3.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '선택';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr[idx].length = <%= gr_cd2.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '선택';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr[idx].length = 1;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '선택';							
			}
			
		}else{
	
			if(fm.eval_off.value == '2' || fm.eval_off.value == '3'){		
				fm.eval_gr.length = <%= gr_cd1.length+1 %>;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '선택';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off.value == '1'){		
				if(fm.eval_gu.value == '1'){
					fm.eval_gr.length = <%= gr_cd3.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '선택';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr.length = <%= gr_cd2.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '선택';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr.length = 1;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '선택';							
			}
			
		}
		
	} 

	//고객 신용평가 조회
	function search_eval()
	{
		window.open("search_eval.jsp?client_id=<%=base.getClient_id()%>", "EVAL", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//다음단계로 넘어가기
	function save(){
		var fm = document.form1;
		
		<%if(!ck_acar_id.equals("000029")){%>
	
		<%if(client.getClient_st().equals("1") && !AddUtil.replace(client.getOpen_year()," ","").equals("")){%>
		if(fm.rent_st.value == '1' && fm.client_st.value == '1'){
			var open_year = '<%=AddUtil.replace(c_db.addMonth(client.getOpen_year(),12),"-","")%>';
			var now = new Date();
			var base_dt = now.getYear()+'0101';
			if(open_year != '' && toInt(open_year) < toInt(base_dt)){
				if(fm.c_ba_year_s.value == '' || fm.c_ba_year.value == '')		{ alert('당기 기준일자를 입력하십시오.'); 	return;}
				if(fm.c_cap.value == '' || fm.c_cap.value == '0')				{ alert('당기 자본금을 입력하십시오.'); 	return;}
			}
		}
		<%}%>
		
		
		var gr_size = toInt(fm.eval_cnt.value);	
		
			
		if(gr_size == 1){				
				if(fm.eval_gr.value == ''){ alert('신용등급을 선택하십시오.'); return;}
				if(fm.eval_off.value != '' && fm.eval_gr.value != '' && fm.eval_s_dt.value == '' && fm.eval_gr.value != '없음' && fm.eval_gr.value != '생략'){ alert('신용등급 조회일자를 입력하십시오.'); return;}	
		
		}else{	
			for(i=0; i<gr_size; i++){
				if(fm.client_st.value != '2' && fm.client_st.value != '1' && i==0 ) continue;			
				if(fm.eval_gr[i].value == ''){ alert('신용등급을 선택하십시오.'); return;}
				if(fm.eval_off[i].value != '' && fm.eval_gr[i].value != '' && fm.eval_s_dt[i].value == '' && fm.eval_gr[i].value != '없음' && fm.eval_gr[i].value != '생략'){ alert('신용등급 조회일자를 입력하십시오.'); return;}	
			}
		}
		
		
		
	 			
	
		if(fm.dec_gr.value == '')			{ alert('적용신용등급을 선택하십시오.'); 			return;}
		if(fm.dec_f_dt.value == '')			{ alert('판정일자를 입력하십시오.'); 			return;}
		
		<%}%>
		
						
		if(confirm('3단계를 등록하시겠습니까?')){		
			fm.action='lc_reg_step3_a.jsp';
			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}

	
	function search_eval_key(){
		window.open("search_eval_key.jsp", "SEARCH_EVAL_KEY", "left=10, top=10, width=900, height=300, scrollbars=yes, status=yes, resizable=yes");	
	}		
	
	function change_eval_input(){
		var fm = document.form1;
		
		var eval_select = fm.eval_select;
		var eval_select_length = eval_select.length;
		
		for(var i=0; i<eval_select_length; i++){
			if(eval_select[i].selectedIndex == 1){
				eval_select[i].nextElementSibling.style.display = 'none';
				eval_select[i].nextElementSibling.value = '';
			} else {
				eval_select[i].nextElementSibling.style.display = 'inline';
			}
		}
	}
	
//-->
</script> 
</head>
<body leftmargin="15">
<form action='lc_reg_step3_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="old_rent_mng_id" 	value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 	value="<%=old_rent_l_cd%>">
  <input type='hidden' name="fin_seq" 			value="<%=c_fin.getF_seq()%>">
  <input type='hidden' name="client_id" 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">  
  <input type='hidden' name="client_guar_st"	value="<%=cont_etc.getClient_guar_st()%>">    
  <input type='hidden' name="rent_st"			value="<%=base.getRent_st()%>">    
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr> 
        <td> 
            <table width='100%'>
                <tr>
                	<td colspan='2'>
                	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                                <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약등록</span></span></td>
                                <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                            </tr>
                        </table>
                	</td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[3단계]</font> 고객신용평가사항</span></td>
                </tr>
                <tr>
                    <td align='left'>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=base.getRent_dt()%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%><%if(base.getReject_car().equals("Y")){%>&nbsp;(인수거부차량)<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><%String rent_way = base.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%><%if(!base.getAgent_emp_id().equals("")){%>&nbsp;(계약진행담당자:<%=c_db.getNameById(base.getAgent_emp_id(),"CAR_OFF_EMP")%>)<%}%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<%=site.getR_site()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
	</tr>
	<tr>
	    <td align="center">
	    <font color="#7F0900">[[
	  	<%if(c_fin.getClient_id().equals("")){%>			
		등록된 신용평가가 없습니다.
		<%}else{%>
		최근 등록된 신용평가로 셋팅하였습니다.
		<%}%>
		]]</font>
	    </td>
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
                    <td width=20%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='text'></td>
                    <td class=title width=10%>소득구분</td>
                    <td>&nbsp;
        			  <select name='pay_st'>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>선택</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>급여소득</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>사업소득</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>기타사업소득</option>
        		            </select>
        			</td>
                    <td class=title width=10%>연소득</td>
                    <td>&nbsp;<input type='text' size='7'  name='pay_type' maxlength='9' class='text' value='<%=client.getPay_type()%>'>&nbsp;만원
        			</td>			
                </tr>
    		    <tr>
        		    <td class='title'>직장명</td>
        		    <td>&nbsp;<input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='15' class='text'></td>
                    <td class=title width=10%>근속연수</td>
                    <td width=20%>&nbsp;
        			<input type='text' size='2' name='wk_year' value='<%=client.getWk_year()%>' maxlength='2' class='text'>년</td>
                    <td class=title width=10%>직위</td>
                    <td>&nbsp;<input type='text' size='11'  name='title' class='text' value='<%=client.getTitle()%>'></td>
    		    </tr>		  
            </table>
        </td>
    </tr>
	<%}else{%>
	<tr>
	    <td><font color=red>♣ <%if(client.getClient_st().equals("1")) 		out.println("법인");
              	else if(client.getClient_st().equals("2"))  out.println("개인");
              	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
              	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
              	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%> ♣</font></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>요약 재무제표</span></td> <!--가장 최근의 재무제표 조회하여 setting-->
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		       
		            <td colspan="2" rowspan="2" class=title>구분<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>당기(
		                <input type='text' name='c_kisu' size='10' value='<%=c_fin.getC_kisu()%>' maxlength='20' class='text' >
		            기)</td>
		            <td width="43%" class=title>전기(
		                <input type='text' name='f_kisu' size='10' value='<%=c_fin.getF_kisu()%>' maxlength='20' class='text' >
		            기)</td>
		        </tr>
		        <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='text' maxlength='10' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='11' class='text' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='text' maxlength='10' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='11' class='text' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
		        </tr>
		        <tr>
		            <td colspan="2" class=title>자산총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>자<br>
		            본</td>
		            <td width="9%" class=title>자본금</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td class=title>자본총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>매출</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>당기순이익</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		    </table>	     
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용등급</span>	        
	        &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:search_eval_key()" onMouseOver="window.status=''; return true" title="신용조회 대체키 조회하기"><img src=/acar/images/center/button_in_cf_dc.gif border=0 align=absmiddle></a>
	    </td>
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
        	<%
      		  	if(client.getClient_st().equals("2")){        		  		
       		  		eval3 = a_db.getContEvalOff(base.getClient_id(), client.getFirm_nm(), "3");
       				eval_cnt++;%>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='3'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getFirm_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                        <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                            <option value="3">KCB</option>
                        </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval3.getEval_score()%>'>
                    </td>
                    <td align="center">
                        <select name='eval_gr' style="width: 118px;">
                            <option value="">선택</option>
                            <option value="없음" <%if(eval3.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                            <option value="생략" <%if(eval3.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
     			    <%for(int i =0; i<gr_cd1.length; i++){
        				CodeBean cd = gr_cd1[i];
        				String scope = "";
        				switch(cd.getNm_cd()){
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
        			%>
                            <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>>
                            	<%=cd.getNm()%><%=scope%>
                            </option>
        		    <%}%>        				  
                        </select>			
        	    </td>
                    <td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>					
                </tr>
                <%		eval5 = a_db.getContEvalOff(base.getClient_id(), client.getFirm_nm(), "2");	
                		eval_cnt++; %>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='5'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getFirm_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="2">NICE</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval5.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval5.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval5.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>        				  
                      </select>			
        			</td>
                    <td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>					
                </tr>                
        		  <%}else{
        		  		eval1 = a_db.getContEvalOff(base.getClient_id(), client.getFirm_nm(), "1");        		  		
        				eval_cnt++;%>
                <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인<input type='hidden' name='eval_gu' value='1'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getFirm_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">                          
                          <option value="1">크레탑</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval1.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval1.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval1.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd3.length; i++){
        						CodeBean cd = gr_cd3[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
                    <td align="center"><input type='text' name='eval_b_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>					
                </tr>
                
                          <!--대표연대보증인-->
                          
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){
        		  			eval2 = a_db.getContEvalOff(base.getClient_id(), client.getClient_nm(), "2");
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='2'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getClient_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="2">NICE</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval2.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval2.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval2.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>        				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <%				eval6 = a_db.getContEvalOff(base.getClient_id(), client.getClient_nm(), "3");
                				eval_cnt++; %>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='6'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getClient_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">                          
                          <option value="3">KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval6.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval6.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval6.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
        				 %>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}%>        				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>
        		  
        		  <!--공동임차인-->
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){ //공동임차인
        		  		
        		  			eval7 = a_db.getContEvalOff(base.getClient_id(), client.getClient_nm(), "2");
        					eval_cnt++;%>
                <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='7'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getClient_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="2">NICE</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval7.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval7.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval7.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>        				 
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <%				eval8 = a_db.getContEvalOff(base.getClient_id(), client.getClient_nm(), "3");
                				eval_cnt++; %>
                <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='8'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=client.getClient_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="3">KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval8.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval8.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval8.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
        				%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}%>        				    
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>
        		          		  
        		  <%}%>
        		  
        		  <!--대표외 연대보증인-->
        		  
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(base.getClient_id(), String.valueOf(gur.get("GUR_NM")));
        				eval_cnt++;%>
                <tr>
                    <td class=title>연대보증인<%=i+1%><input type='hidden' name='eval_gu' value='4'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=gur.get("GUR_NM")%>'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval4.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval4.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval4.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">입력</option>
                    		<option value="2">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval4.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval4.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval4.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>                          
        				  <%if(eval4.getEval_off().equals("2")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}
        				   }%>
        				  
        				  <%if(eval4.getEval_off().equals("1")){
        				    for(int j =0; j<gr_cd2.length; j++){
        						CodeBean cd = gr_cd2[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>					
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	}
        		  	}%>
            </table>
        </td>
    </tr>
	<input type='hidden' name="eval_cnt"			value="<%=eval_cnt%>">  
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자산현황</span></td>
	</tr>
	<%int zip_cnt =0;%>
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
                <tr>
                    <td class=title>계약자</td>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.address;
									
								}
							}).open();
						}
					</script>			
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="45" value="<%=eval3.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.address;
									
								}
							}).open();
						}
					</script>			
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="45" value="<%=eval3.getAss2_addr()%>">
					</td>
                </tr> 
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                  <%}else{%>
                <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인</td>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode2() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip2').value = data.zonecode;
									document.getElementById('t_addr2').value = data.address;
									
								}
							}).open();
						}
					</script>	
					
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip2" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=eval1.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode3() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip3').value = data.zonecode;
									document.getElementById('t_addr3').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip3" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="<%=eval1.getAss2_addr()%>">
					</td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip4" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr4" size="25" value="<%=eval2.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
                    <script>
						function openDaumPostcode5() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip5').value = data.zonecode;
									document.getElementById('t_addr5').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip5" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode5()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr5" size="25" value="<%=eval2.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
        		  <% 	} %>
        		  
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){%>
                <tr>
                    <td class=title>공동임차인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode6() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip6').value = data.zonecode;
									document.getElementById('t_addr6').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip6" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode6()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr6" size="25" value="<%=eval7.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
                    <script>
						function openDaumPostcode7() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip7').value = data.zonecode;
									document.getElementById('t_addr7').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip7" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode7()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr7" size="25" value="<%=eval7.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
        		  <% 	} %>
        		          		  
        		  <% } %>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(base.getClient_id(), String.valueOf(gur.get("GUR_NM")));%>		  	  
                <tr>
                    <td class=title>연대보증인<%=i+1%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode8() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip8').value = data.zonecode;
									document.getElementById('t_addr8').value = data.address;
									
								}
							}).open();
						}
					</script>	
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip8" size="7" maxlength='7' value="<%=eval4.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode8()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr8" size="25" value="<%=eval4.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>            
        			<td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode9() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip9').value = data.zonecode;
									document.getElementById('t_addr9').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip" id="t_zip9" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode9()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr9" size="25" value="<%=eval4.getAss2_addr()%>">
					</td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타참고사항</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>기타</td>
                    <td>&nbsp;<textarea name='dec_etc' rows='5' cols='100'><%=cont_etc.getDec_etc()%></textarea></td>
                </tr>
    		</table>	  
	    </td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용등급판정</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>적용신용등급</td>
                    <td colspan="2" class=title>심사</td>
                    <td colspan="2" class=title>결재</td>
                </tr>
                <tr>
                    <td width="20%" class=title>담당자</td>
                    <td width="20%" class='title'>판정일자</td>
                    <td width="20%" class=title>결재자</td>
                    <td width="27%" class='title'>결재일자</td>
                </tr>
                <tr>
                    <td align="center">
                     <select name='dec_gr'>
                          <%if(base.getCar_gu().equals("1")){//신차%>
                          <option value="2" >초우량기업</option>
                          <option value="1" >우량기업</option>
                          <%}else if(base.getCar_gu().equals("0")){//재리스%>
                          <option value="1" >우량기업</option>
                          <option value="0" >일반고객</option>
                          <%}%>
                          <!--
                          <option value="">선택</option>
                          <option value="3" <%if(max_cont_etc.getDec_gr().equals("3")){%>selected<%}%>>신설법인</option>
                          <option value="0" <%if(max_cont_etc.getDec_gr().equals("0")){%>selected<%}%>>일반고객</option>
                          -->
                      </select>
                    </td>
                    <td align="center">
                        -			
			<input type="hidden" name="dec_f_id" value="">			
                   </td>
                   <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="<%//=AddUtil.ChangeDate2(max_cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                   <td align="center">
                        -                         
			<input type="hidden" name="dec_l_id" value="">			
                    </td>
                    <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value="<%//=AddUtil.ChangeDate2(max_cont_etc.getDec_l_dt())%>" disabled ></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
		<td align='right'><a href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
    <%}%>
	<tr>
        <td></td>
    </tr>
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약삭제",ck_acar_id)){%>
    <tr>
        <td align='right'>
	    <a href="lc_reg_step2.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp;
	    <a href="lc_reg_step4.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp;
	    <a href="lc_b_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;  
	    <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	
	    </td>
    </tr>
	<%}%>
</table>
</form>
</body>
</html>
