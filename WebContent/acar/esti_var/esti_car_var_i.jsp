<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String disabled = "";
	if(!seq.equals("")) disabled = "disabled";
		
	//차종변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCarVarCase(a_e, a_a, seq);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] sgroups = c_db.getCodeAll2("0008", "Y"); /* 코드 구분:차량소분류 */
	int sgroup_size = sgroups.length;		
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(fm.a_e.value == ''){ alert('소분류를 선택하십시오.'); return;}
		if(cmd == 'i'){
			fm.h_a_a.value = fm.a_a.value;
			fm.h_a_c.value = fm.a_c.value;
			fm.h_m_st.value = fm.m_st.value;
			fm.h_a_e.value = fm.a_e.value;									
			if(!confirm('등록하시겠습니까?')){	return;	}
		}else if(cmd == 'up'){
			fm.h_a_a.value = fm.a_a.value;
			fm.h_a_c.value = fm.a_c.value;
			fm.h_m_st.value = fm.m_st.value;
			fm.h_a_e.value = fm.a_e.value;											
			if(!confirm('입력한 데이타로 업그레이드합니다.\n\n진짜로 업그레이드하시겠습니까?')){	return;	}						
		}else{
			if(!confirm('수정하시겠습니까?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
	
	//목록보기
	function go_list(){
		location='esti_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>';
	}
	
	//대분류 선택시 중분류 디스플레이
	function change_m(){
		var fm = document.form1;
		drop_m();
		if(fm.a_c.value == '승용'){ //선택
			fm.m_st.options[0] = new Option('일반형 승용', '일반형 승용');
			fm.m_st.options[1] = new Option('리무진', '리무진');
			fm.m_st.options[2] = new Option('일반형 승용 LPG', '일반형 승용 LPG');
			fm.m_st.options[3] = new Option('5인승 짚', '5인승 짚');
			fm.m_st.options[4] = new Option('7~8인승', '7~8인승');
			fm.m_st.options[5] = new Option('9~10인승', '9~10인승');									
		}else if(fm.a_c.value == '승합'){
			fm.m_st.options[0] = new Option('승합', '승합');
		}else if(fm.a_c.value == '화물'){
			fm.m_st.options[0] = new Option('화물', '화물');
		}
		change_s();
	}	
	function drop_m(){
		var fm = document.form1;
		var len = fm.m_st.length;
		for(var i = 0 ; i < len ; i++){
			fm.m_st.options[len-(i+1)] = null;
		}
	}		
	
	//중분류 선택시 소분류 디스플레이
	function change_s(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.a_e;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.a_e";
		fm2.a_c.value = fm.a_c.value;
		fm2.m_st.value = fm.m_st.value;	
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}	
	
	function OpenList(c_st){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;
		var br_id = fm.br_id.value;
		var SUBWIN = "../add_mark/s_code_i.jsp";
		window.open(SUBWIN+"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&c_st="+c_st, "OpenList", "left=100, top=100, width=575, height=500, scrollbars=yes");
	}		
//-->
</script>
</head>
<body>
<form action="./esti_var_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="a_c" value="">
  <input type="hidden" name="m_st" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
</form>
<form name="form1" method="post" action="esti_car_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="h_a_a" value="<%=a_a%>">
  <input type="hidden" name="h_a_c" value="<%=bean.getA_c()%>">            
  <input type="hidden" name="h_m_st" value="<%=bean.getM_st()%>">            
  <input type="hidden" name="h_a_e" value="<%=bean.getA_e()%>">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 견적변수관리 > <span class=style5>차종별변수 <%if(seq.equals("")){%>
                    등록 
                    <%}else{%>
                    수정
                    <%}%></span></span>
                    </td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
	    <%    if(seq.equals("")){%>
	    <a href="javascript:save('i');"><img src=../images/center/button_reg.gif border=0></a> 
	    <%    }else{%>
	    <a href="javascript:save('u');"><img src=../images/center/button_modify.gif border=0></a> 	  
	    <a href="javascript:save('up');"><img src=../images/center/button_upgrade.gif border=0></a> 	  	  
	    <%    }%>
	    <%}%>
	    <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>        
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title>대여구분</td>
                    <td colspan="5"> 
                      <select name="a_a" <%=disabled%>>
                        <option value="1" <%if(a_a.equals("1"))%>selected<%%>>리스</option>
                        <option value="2" <%if(a_a.equals("2"))%>selected<%%>>렌트</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=12%>대분류</td>
                    <td width=21%> 
                      <select name="a_c" onChange='javascript:change_m()' <%=disabled%>>
                        <option value="승용" <%if(bean.getA_c().equals("승용")||bean.getA_c().equals(""))%>selected<%%>>승용</option>
                        <option value="승합" <%if(bean.getA_c().equals("승합"))%>selected<%%>>승합</option>
                        <option value="화물" <%if(bean.getA_c().equals("화물"))%>selected<%%>>화물</option>
                      </select>
                    </td>
                    <td class=title width=12%>중분류</td>
                    <td width=21%> 
                      <select name="m_st" onChange='javascript:change_s()' <%=disabled%>>
        			  <%if(bean.getA_c().equals("승용") || bean.getA_c().equals("")){%>
                        <option value="일반형 승용" <%if(bean.getM_st().equals("일반형 승용") || bean.getM_st().equals(""))%>selected<%%>>일반형 승용</option>
                        <option value="리무진" <%if(bean.getM_st().equals("리무진"))%>selected<%%>>리무진</option>
                        <option value="일반형 승용 LPG" <%if(bean.getM_st().equals("일반형 승용 LPG"))%>selected<%%>>일반형 승용 LPG</option>
                        <option value="5인승 짚" <%if(bean.getM_st().equals("5인승 짚"))%>selected<%%>>5인승 짚</option>
                        <option value="7~8인승" <%if(bean.getM_st().equals("7~8인승"))%>selected<%%>>7~8인승</option>
                        <option value="9~10인승" <%if(bean.getM_st().equals("9~10인승"))%>selected<%%>>9~10인승</option>	
        			  <%}else if(bean.getA_c().equals("승합")){%>	
        				<option value="승합" <%if(bean.getM_st().equals("승합"))%>selected<%%>>승합</option>
        			  <%}else if(bean.getA_c().equals("화물")){%>	
                        <option value="화물" <%if(bean.getM_st().equals("화물"))%>selected<%%>>화물</option>
        			  <%}%>	
                      </select>
                    </td>
                    <td class=title width=12%>소분류</td>
                    <td width=22%> 
                      <select name="a_e" <%=disabled%>>		
                        <%if(sgroup_size > 0 && seq.equals("")){
        					for(int i = 0 ; i < 7 ; i++){
        						CodeBean sgroup = sgroups[i];%>
                        <option value='<%= sgroup.getNm_cd()%>' <%if(bean.getA_e().equals(sgroup.getNm_cd()))%>selected<%%>><%= sgroup.getNm()%></option>
                        <%	}
        				}else{
        					Vector cars = e_db.getSearchCode(bean.getA_c(), bean.getM_st());
        					int car_size = cars.size();
        					for(int i = 0 ; i < car_size ; i++){
        						Hashtable car = (Hashtable)cars.elementAt(i);%>
        				<option value='<%=car.get("NM_CD")%>' <%if(bean.getA_e().equals(String.valueOf(car.get("NM_CD"))))%>selected<%%>><%=car.get("NM")%></option>
        				<%	}%>
        				<%}%>
                      </select>&nbsp;<a href="javascript:OpenList('0008')"><img src=../images/center/button_in_sbrgl.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>분류기준</td>
                    <td colspan="5"> 
                      <input type="text" name="s_sd" value='<%=bean.getS_sd()%>' size="100" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>해당차종<br>
                  (주요차종)</td>
                <td colspan="5"> 
                    <textarea name="cars" cols="100" class="text" rows="2"><%=bean.getCars()%></textarea>
                </td>
                </tr>
                <tr> 
                    <td class=title>견적적용일</td>
                    <td colspan="5"> 
                      <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(bean.getA_j())%>' size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>        
        <td><span class=style2>1. 핵심변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
                <!--
                <tr> 
                    <td class=title width=20%>최대잔가율</td>
                    <td> 48개월 
                      <input type="text" name="o_13_7" value='<%=bean.getO_13_7()%>' size="6" class=num>
                      %, 42개월 
                      <input type="text" name="o_13_6" value='<%=bean.getO_13_6()%>' size="6" class=num>
                      %, 36개월 
                      <input type="text" name="o_13_5" value='<%=bean.getO_13_5()%>' size="6" class=num>
                      %, 30개월 
                      <input type="text" name="o_13_4" value='<%=bean.getO_13_4()%>' size="6" class=num>			  
                      %, 24개월 
                      <input type="text" name="o_13_3" value='<%=bean.getO_13_3()%>' size="6" class=num>
                      %, 18개월 
                      <input type="text" name="o_13_2" value='<%=bean.getO_13_2()%>' size="6" class=num>
                      %, 12개월 
                      <input type="text" name="o_13_1" value='<%=bean.getO_13_1()%>' size="6" class=num>
                      % (VAT포함) </td>
                </tr>
                 
                <tr> 
                    <td class=title>기본식 일반관리비/월(적용x,소스)</td>
                    <td>
                      <input type="text" name="g_6" value='<%=AddUtil.parseDecimal(bean.getG_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>일반식 추가관리비/월(적용x,소스)</td>
                    <td> 
                      <input type="text" name="g_7" value='<%=AddUtil.parseDecimal(bean.getG_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>영업사원 수당율</td>
                    <td> 
                      <input type="text" name="o_11" value='<%=bean.getO_11()%>' size="10" class=num>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title>현재 아마존카 종합보험료</td>
                    <td> 
                      <input type="text" name="g_2" value='<%=AddUtil.parseDecimal(bean.getG_2())%>' size="10" class=num>
                      원 (만단위반올림)</td>
                </tr>
                <tr> 
                    <td class=title>신설법인 업무용차량 자차보험요율</td>
                    <td> 
                      <input type="text" name="g_4" value='<%=bean.getG_4()%>' size="10" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>만21세이상 운전보험 가입시<br>대여료 인상2</td>
                    <td> 
                      <input type="text" name="oa_d" value='<%=AddUtil.parseDecimal(bean.getOa_d())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      (금액)</td>
                </tr>
                <!-- 
                <tr> 
                    <td class=title>탁송료</td>
                    <td> 
                      <input type="text" name="o_4" value='<%=AddUtil.parseDecimal(bean.getO_4())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>                
                <tr> 
                    <td class=title>LPG키트 장착료</td>
                    <td> 48개월 
                      <input type="text" name="oa_e_7" value='<%=AddUtil.parseDecimal(bean.getOa_e_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 42개월 
                      <input type="text" name="oa_e_6" value='<%=AddUtil.parseDecimal(bean.getOa_e_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 36개월 
                      <input type="text" name="oa_e_5" value='<%=AddUtil.parseDecimal(bean.getOa_e_5())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 30개월 
                      <input type="text" name="oa_e_4" value='<%=AddUtil.parseDecimal(bean.getOa_e_4())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 24개월 
                      <input type="text" name="oa_e_3" value='<%=AddUtil.parseDecimal(bean.getOa_e_3())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 18개월 
                      <input type="text" name="oa_e_2" value='<%=AddUtil.parseDecimal(bean.getOa_e_2())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 12개월 
                      <input type="text" name="oa_e_1" value='<%=AddUtil.parseDecimal(bean.getOa_e_1())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'> 
                    </td>
                </tr>
                -->
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>        
        <td><span class=style2>2. 기타변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
            <!-- 
                <tr> 
                    <td class=title width=20%>특소세율</td>
                    <td> 
                      <input type="text" name="o_2" value='<%=bean.getO_2()%>' size="10" class=num>
                      % (주민세포함)</td>
                </tr>                 
                <tr> 
                    <td class=title>취득세율</td>
                    <td> 
                      <input type="text" name="s_f" value='<%=bean.getS_f()%>' size="10" class=num>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title>등록세율</td>
                    <td> 
                      <input type="text" name="o_5" value='<%=bean.getO_5()%>' size="10" class=num>
                      %</td>
                </tr>
                <!-- 
                <tr> 
                    <td class=title>과세표준액 기준 채권매입율<br>
                      및 차종 채권매입액</td>
                    <td> 서울 
                      <input type="text" name="o_6" value='<%=AddUtil.parseDecimal(bean.getO_6())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 경기 
                      <input type="text" name="o_7" value='<%=AddUtil.parseDecimal(bean.getO_7())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                 -->
                <tr> 
                    <td class=title rowspan="3">자동차세/년</td>
                    <td> 7~9인승제외 : cc당 
                      <input type="text" name="o_14" value='<%=AddUtil.parseDecimal(bean.getO_14())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 차종별 
                      <input type="text" name="o_15" value='<%=AddUtil.parseDecimal(bean.getO_15())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                <!-- 
                <tr> 
                    <td> 7~9인승 2004년 : cc당 
                      <input type="text" name="o_a" value='<%=AddUtil.parseDecimal(bean.getO_a())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 차종별 
                      <input type="text" name="o_b" value='<%=AddUtil.parseDecimal(bean.getO_b())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td> 7~9인승 2007년 : cc당 
                      <input type="text" name="o_c" value='<%=AddUtil.parseDecimal(bean.getO_c())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      , 차종별 
                      <input type="text" name="o_d" value='<%=AddUtil.parseDecimal(bean.getO_d())%>' size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
                 -->
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>