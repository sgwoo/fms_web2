<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.esti_mng.*, acar.car_office.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<jsp:useBean id="EstiContBn" class="acar.esti_mng.EstiContBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	EstiRegBn = EstiMngDb.getEstiReg(est_id);
	String est_st = EstiRegBn.getEst_st();
	String emp_id = EstiRegBn.getEmp_id();
	
	//견적내용리스트
	Vector EstiList = EstiMngDb.getEstiLists(est_id);
	//견적진행내용-메모
	Vector EstiCont = EstiMngDb.getEstiConts(est_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	if(!emp_id.equals("")){
		coe_bean = cod.getCarOffEmpBean(emp_id);
		co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
	
	/* 코드 구분:대여상품명 */
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); 
	int good_size = goods.length;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//목록보기
	function go_list(){
		<%if(est_st.equals("3")){%>
		location='../esti_end/esti_end_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>';
		<%}else{%>
		location='esti_ing_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>';
		<%}%>
	}
	
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}	
		
	//견적내용보기
	function list_display(){
		var fm = document.form1;	
		if(tr_list.style.display == 'none'){
			tr_list.style.display	= '';
		}else{
			tr_list.style.display	= 'none';
		}
	}
	//하단페이지
	function sub_action(idx){
		var fm = document.form1;		
		fm.target = "i_in";
		fm.action = "./esti_sub"+idx+".jsp?seq=";
		fm.submit();
	}
	//진행내용 수정하기
	function EstiContUpd(seq){
		var fm = document.form1;
		var SUBWIN="./esti_sub_upd.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&est_id=<%=est_id%>&seq="+seq;	
		window.open(SUBWIN, "esti_update", "left=100, top=100, width=850, height=300, scrollbars=yes, status=yes");		
//		alert('작업중');
//		return;
	}	
	//진행내용 수정하기
	function cont_update(seq){
		var fm = document.form1;		
		fm.target = "i_in";
		fm.action = "./esti_sub1.jsp?seq="+seq;
		fm.submit();		
	}	
	//거래처 동일견적보기	
	function esti_firm_list(gubun){
		var SUBWIN="./esti_firm_list.jsp?gubun="+gubun+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&est_id=<%=est_id%>";	
		window.open(SUBWIN, "esti_firm_list", "left=100, top=100, width=800, height=500, scrollbars=yes, status=yes");
	}
	
	
	//견적내기
	function EstiReg(){
		var fm = i_in.form1;	
		if(fm.reg_dt.value == '')				{ alert('등록(마감)일자를 입력하십시오'); 	return; }
		if(fm.reg_id.value == '')				{ alert('등록자를 선택하십시오'); 			return; }

		var ch_date = replaceString("-","",fm.reg_dt.value);
		if(ch_date!=""){
			if(ch_date.length!=8){
				alert('날짜의 형식은 "2002-01-23" 또는 "200020123" 입니다.');
				return;
			}
		}
			
		if(fm.sub_st.value == '3'){
			if(fm.end_type[1].checked == true){
				if(fm.nend_st.value == '')		{ alert('미체결구분을 선택하십시오.'); 		return; }
				if(fm.nend_cau.value == '')		{ alert('미체결사유를 선택하십시오.'); 		return; }
			}
		}else if(fm.sub_st.value == '2'){
			if(fm.cont.value == '')				{ alert('내용을 입력하십시오'); 			return; }
		}else{
			if(fm.title.value == '' && fm.cont.value == '')
												{ alert('내용을 입력하십시오'); 			return; }
		}

		if(!confirm('등록하시겠습니까?')){	return; }
		fm.action = 'esti_sub_a.jsp';
		fm.target = "i_no";
		fm.submit();
	}	
	
	//견적내용추가하기
	function esti_list_add(){
		var fm = document.form1;
		if(fm.a_a.value == '')			{ alert('대여상품을 선택하십시오'); return; }
		if(fm.a_b.value == '')			{ alert('대여기간을 입력하십시오'); return; }
		if(fm.fee_amt.value == '' || fm.fee_amt.value == '0')
										{ alert('월대여료를 입력하십시오'); return; }
		if(!confirm('등록하시겠습니까?')){	return; }
		fm.action = 'esti_ing_add.jsp';
//		fm.target = "d_content";
		fm.target = "i_no";
		fm.submit();
	}
	//수정하기
	function EstiUpd(){
		var fm = document.form1;
		var SUBWIN="./esti_ing_upd.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&est_id=<%=est_id%>";	
		window.open(SUBWIN, "esti_update", "left=100, top=100, width=850, height=600, scrollbars=yes, status=yes");	
	}
	//삭제하기
	function EstiDel(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return; }
		if(!confirm('정말 정말 삭제하시겠습니까?')){	return; }		
		fm.action = 'esti_ing_d_a.jsp';
//		fm.target = "d_content";
		fm.target = "i_no";
		fm.submit();
	}	
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="./esti_ing_i_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">
    <input type="hidden" name="gubun6" value="<%=gubun6%>">
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="s_year" value="<%=s_year%>">
    <input type="hidden" name="s_mon" value="<%=s_mon%>">
    <input type="hidden" name="s_day" value="<%=s_day%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="est_st" value="<%=est_st%>">
    <input type="hidden" name="mode" value="<%=mode%>">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>견적진행관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right" colspan=2>
        	<%if(est_st.equals("3") && !mode.equals("view")){%>
        	<a href="javascript:EstiUpd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
    		<%}%>	
    		&nbsp;	  
    	    <%if(!mode.equals("view")){%>
    	    <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
    	    <%}%>
	    </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>견적일자</td>
                    <td width=14%>&nbsp;<%= AddUtil.ChangeDate2(EstiRegBn.getEst_dt()) %></td>
                    <td class=title width=11%>담당자</td>
                    <td width=14%>&nbsp;<%= c_db.getNameById(EstiRegBn.getMng_id(), "USER")%></td>
                    <td class=title width=11%>견적구분</td>
                    <td width=14%> 
                      <%if(EstiRegBn.getCar_type().equals("1")){%>
                      &nbsp;신차 
                      <%}else{%>
                      &nbsp;재리스 
                      <%}%>
                    </td>
                    <td class=title width=11%>견적상태</td>
                    <td width=14%> <font color="#FF0000"> 
                      <%if(est_st.equals("2")){%>
                      &nbsp;보류중 
                      <%}else if(est_st.equals("3")){%>
                      &nbsp;마감 
                      <%}else{%>
                      &nbsp;진행중 
                      <%}%>
                      </font> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <%if(!emp_id.equals("")){%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원</span></td>
        <td align="right"><a href="javascript:esti_firm_list('emp')"><img src=/acar/images/center/button_gjir_yus.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>영업사원명</td>
                    <td width=39%>&nbsp;<%= coe_bean.getEmp_nm()%> <%= coe_bean.getEmp_pos()%></td>
                    <td class=title width=11%>근무처</td>
                    <td width=39%>&nbsp;<%= coe_bean.getCar_comp_nm()%> <%= coe_bean.getCar_off_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>전화번호</td>
                    <td>&nbsp;<%= coe_bean.getEmp_m_tel()%></td>
                    <td class=title>팩스번호</td>
                    <td>&nbsp;<%= co_bean.getCar_off_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    <%if(!EstiRegBn.getEst_nm().equals("") || !EstiRegBn.getEst_mgr().equals("")){%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처</span></td>
        <td align="right"><a href="javascript:esti_firm_list('firm')"><img src=/acar/images/center/button_gjir.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>거래처명</td>
                    <td width=39%>&nbsp;<%= EstiRegBn.getEst_nm()%></td>
                    <td class=title width=11%>담당자</td>
                    <td width=39%>&nbsp;<%= EstiRegBn.getEst_mgr()%></td>
                </tr>
                <tr> 
                    <td class=title>전화번호</td>
                    <td>&nbsp;<%= EstiRegBn.getEst_tel()%></td>
                    <td class=title>팩스번호</td>
                    <td>&nbsp;<%= EstiRegBn.getEst_fax()%></td>
                </tr>
                <tr> 
                    <td class=title>신용구분</td>
                    <td colspan="3"> 
        			 <%if(EstiRegBn.getSpr_kd().equals("0")){%>&nbsp;일반고객<%}%>
        			 <%if(EstiRegBn.getSpr_kd().equals("1")){%>&nbsp;우량기업<%}%>
        			 <%if(EstiRegBn.getSpr_kd().equals("2")){%>&nbsp;초우량기업<%}%>
        			 <%if(EstiRegBn.getSpr_kd().equals("3")){%>&nbsp;신설법인<%}%>			 			 			 
                    </td>
                </tr>		  		  
            </table>
        </td>
    </tr>
    <%}%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>차종</td>
                    <td width=89%>&nbsp;<%= EstiRegBn.getCar_name()%> 
                      <%if(EstiRegBn.getCar_type().equals("2")){%>
                      ( <a href="javascript:view_car('','','<%= EstiRegBn.getCar_mng_id()%>')"><%= EstiRegBn.getCar_no()%></a> 
                      ) 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차량가격</td>
                    <td>&nbsp;<%= AddUtil.parseDecimal(EstiRegBn.getO_1())%>원 <font color="#999999">(기본가격<%= AddUtil.parseDecimal(EstiRegBn.getCar_amt())%>원 
                      + 옵션 <%= AddUtil.parseDecimal(EstiRegBn.getOpt_amt())%>원 
                      <%if(EstiRegBn.getCar_type().equals("2")){%>
                      - 감가상각 <%= AddUtil.parseDecimal(EstiRegBn.getCar_amt()+EstiRegBn.getOpt_amt()-EstiRegBn.getO_1())%>원 
                      <%}%>
                      )</font></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
        <%if(est_st.equals("3") || est_st.equals("2") || mode.equals("view")){%>
        <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적내용</span>
        <%}else{%>
        <img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적내용</span> <a href="javascript:list_display()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a> 
        <%}%>
        </td>
        <td align="right"> <font color="#CCCCCC">(부가세포함) </font> <%=EstiList.size()%>건</td>
    </tr>
    <tr id=tr_list style="display:<%if(est_st.equals("3") || est_st.equals("2") || mode.equals("view")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=line2 colspan=7 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width="6%">연번</td>
                    <td class=title width="21%">상품명</td>
                    <td class=title width="13%">대여기간</td>
                    <td class=title width="17%">월대여료</td>
                    <td class=title width="17%">초기납입금</td>
                    <td class=title width="13%">적용잔가율</td>
                    <td class=title width="13%">보증보험</td>
                </tr>
              <% if(EstiList.size()>0){
    				for(int i=0; i<EstiList.size(); i++){ 
    					EstiListBn = (EstiListBean)EstiList.elementAt(i); %>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%= c_db.getNameByIdCode("0009", "", EstiListBn.getA_a())%></td>
                    <td align="center"><%= EstiListBn.getA_b()%>개월</td>
                    <td align="right"><%= AddUtil.parseDecimal(EstiListBn.getFee_amt())%>원 
                    </td>
                    <td align="right"><%= AddUtil.parseDecimal(EstiListBn.getPp_amt())%>원 
                    </td>
                    <td align="center"> 
                      <%if(EstiListBn.getRo_13().equals("")){%>
                      - 
                      <%}else{%>
                      <%= EstiListBn.getRo_13()%>% 
                      <%}%>
                    </td>
                    <td align="center"> 
                      <%if(EstiListBn.getGu_yn().equals("0")){%>
                      면제 
                      <%}else{%>
                      가입 
                      <%}%>
                    </td>
                </tr>
              <% 		}
    			}else{ %>
              <% } %>
              <%if(!est_st.equals("3") && !mode.equals("view")){%>
                <tr> 
                    <td align="center">추가 
                      <input type="hidden" name="seq" value="<%=EstiList.size()+1%>">
                    </td>
                    <td align="center"> 
                      <select name="a_a">
                        <option value="">= &nbsp;&nbsp;선 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;택 
                        &nbsp;&nbsp;=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="a_b" size="2" class=num>
                      개월</td>
                    <td align="right"> 
                      <input type="text" name="fee_amt" value="" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td align="right"> 
                      <input type="text" name="pp_amt" value="" size="10" class=num onBlur='javscript:this.value = parseDecimal(this.value);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ro_13" size="5" class=num>
                      %</td>
                    <td align="center"> 
                      <select name="gu_yn">
                        <option value="0" >면제</option>
                        <option value="1" selected>가입</option>
                      </select>
                      <a href="javascript:esti_list_add()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                </tr>
              <% } %>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr> 
        <td colspan="2" style="background-color:c6c6c6; height:1;"></td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>진행내용</span></td>
        <td align="right">
        <!--<%=EstiCont.size()%>건-->
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class="line" colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width="6%">연번</td>
                    <td class=title width="10%">등록일자</td>
                    <td class=title width="8%">등록자</td>
                    <td class=title width="19%">제목</td>
                    <td class=title width="57%">내용</td>
                </tr>
              <% if(EstiCont.size()>0){
    				for(int i=0; i<EstiCont.size(); i++){ 
    					EstiContBn = (EstiContBean)EstiCont.elementAt(i);
    					if(!EstiContBn.getEnd_type().equals("")) continue; %>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center">
        			<%if(user_id.equals(EstiContBn.getReg_id())){%>
        			<a href="javascript:EstiContUpd('<%= EstiContBn.getSeq()%>');"><%= AddUtil.ChangeDate2(EstiContBn.getReg_dt())%></a>
        			<%}else{%>
        			<%= AddUtil.ChangeDate2(EstiContBn.getReg_dt())%>
        			<%}%>
        			</td>
                    <td align="center"><%= c_db.getNameById(EstiContBn.getReg_id(), "USER")%></td>
                    <td>&nbsp;<%= EstiContBn.getTitle()%></td>
                    <td>&nbsp;<%= Util.htmlBR(AddUtil.replace(EstiContBn.getCont(),"\"","&#34;"))%></td>
                </tr>
              <% 		}
    			}else{ %>
                <tr> 
                    <td colspan="5" align="center">해당 데이터가 없습니다.</td>
                </tr>
              <% }%>
            </table>
        </td>
    </tr>
    <%if(!est_st.equals("3") && !mode.equals("view")){%>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr align="center"> 
        <td colspan="2"><a href="javascript:sub_action(1);"><img src=/acar/images/center/button_gj_regjh.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
        <%if(!est_st.equals("2")){%>
        <a href="javascript:sub_action(2);"><img src=/acar/images/center/button_gj_brcr.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
        <%}%>
        <a href="javascript:sub_action(3);"><img src=/acar/images/center/button_gj_mgcr.gif align=absmiddle border=0></a> 
		<%if(user_id.equals(EstiRegBn.getMng_id())){%>
	    <a href="javascript:EstiUpd();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
        <a href="javascript:EstiDel();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a> 
        <%}%>
	    </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="./esti_sub1.jsp?est_id=<%=est_id%>&est_st=<%=EstiRegBn.getEst_st()%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>" name="i_in" width="100%" height="180" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
    </tr>
    <!--
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right">&nbsp; </td>
      <td align="right"><a href="javascript:EstiReg();"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      <td align="right">&nbsp;</td>
    </tr>
	-->
	<%}%>
    <%if(est_st.equals("3")){
		EstiContBn = EstiMngDb.getEstiContEnd(est_id);
	%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>마감내용</span></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class="line" colspan=2> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=11%>마감일자</td>
                    <td width=39%>
        			&nbsp;<%if(user_id.equals(EstiContBn.getReg_id())){%>
        			<a href="javascript:EstiContUpd('<%= EstiContBn.getSeq()%>');"><%= AddUtil.ChangeDate2(EstiContBn.getReg_dt())%></a>
        			<%}else{%>
        			<%= AddUtil.ChangeDate2(EstiContBn.getReg_dt())%>
        			<%}%>
        			</td>
                    <td class=title width=11%>등록자</td>
                    <td width=39%>&nbsp;<%= c_db.getNameById(EstiContBn.getReg_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>마감결과</td>
                    <td colspan="3"> 
                      <%if(EstiContBn.getEnd_type().equals("Y")){%>
                      &nbsp;계약체결 
                      <%}else{%>
                      &nbsp;계약미체결 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>미체결구분</td>
                    <td> 
                      <%if(EstiContBn.getNend_st().equals("1")){%>
                      &nbsp;타사계약 
                      <%}else if(EstiContBn.getNend_st().equals("2")){%>
                      &nbsp;자가용구입 
                      <%}else if(EstiContBn.getNend_st().equals("3")){%>
                      &nbsp;장기보류 
                      <%}else if(EstiContBn.getNend_st().equals("4")){%>
                      &nbsp;기타 
                      <%}%>
                    </td>
                    <td class=title>미체결사유</td>
                    <td> 
                      <%if(EstiContBn.getNend_cau().equals("1")){%>
                      &nbsp;대여료 
                      <%}else if(EstiContBn.getNend_cau().equals("2")){%>
                      &nbsp;선수금 
                      <%}else if(EstiContBn.getNend_cau().equals("3")){%>
                      &nbsp;보증보험 
                      <%}else if(EstiContBn.getNend_cau().equals("4")){%>
                      &nbsp;신용도 
                      <%}else if(EstiContBn.getNend_cau().equals("5")){%>
                      &nbsp;부가세 
                      <%}else if(EstiContBn.getNend_cau().equals("6")){%>
                      &nbsp;인지도 
                      <%}else if(EstiContBn.getNend_cau().equals("7")){%>
                      &nbsp;기타 
                      <%}%>
                     </td>
                </tr>
                <tr> 
                    <td class=title>상세내용</td>
                    <td colspan="3">&nbsp;<%= Util.htmlBR(AddUtil.replace(EstiContBn.getCont(),"\"","&#34;"))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <%if(mode.equals("view")){%>
    <tr> 
        <td align="right" colspan=2> <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>