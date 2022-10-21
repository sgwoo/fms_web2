<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	//로그인ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(AddUtil.parseInt(s_height)==800) height = height+180;
	if(AddUtil.parseInt(s_height)==768) height = height+148;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script>
	function view_memo(m_id, l_cd)
	{
		var auth_rw = document.form1.auth_rw.value;		

		//단기대여(월렌트)
		if(m_id == '' && l_cd.length ==6){
			var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+l_cd+"&c_id=&user_id=<%=ck_acar_id%>";	
			window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");					
		//장기대여
		}else{
			window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
		}
	}
	
	//정산 세부내용 보기
	function view_settle(mode, m_id, l_cd, client_id, c_id, gubun3){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;		
		fm.client_id.value = client_id;
		fm.target = "d_content";		
		if(mode=='cont' && l_cd.length == 6){
			fm.mode.value = "client";
		}else{
			fm.mode.value = mode;				
		}

		if(gubun3 == '업무대여'){			
			fm.action = "/acar/settle_acc/settle_c.jsp";		
			fm.submit();
		}else{
			fm.action = "/acar/settle_acc/settle_c.jsp";					
			fm.submit();
		}
	}

	//중도해지정산  보기
	function view_settle_doc(m_id, l_cd, use_yn){
	  	if (use_yn == 'Y' ) {
	  	
			window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
		} else {
			window.open("/acar/cls_con/cls_u1.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE1", "left=100, top=10, width=840, height=650, scrollbars=yes, status=yes");		
		
		}	
	}	

	//내용증명발송요청 이력보기
	function view_credit_req(){
		window.open("settle_acc_doc_req_list.jsp?user_id=<%=user_id%>", "VIEW_CREDIT_REQ_H", "left=10, top=10, width=1000, height=650, scrollbars=yes, status=yes");
	}	
	
	//내용증명발송요청
	function select_credit_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "사용중인 계약과 해지된 계약을 한번에 요청할 수 없습니다." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//사용중인 계약과 해지된 계약을 한번에 요청할수 없습니다.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		if(!confirm('내용증명발송요청 하십겠습니까? \n\n팝업된 페이지에서 계약별 주소종류, 비고, 최고장종류, 유예기간 등을 입력하면 채권담당자에게 메시지가 갑니다.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_doc_req.jsp";
		fm.submit();	
	}					
	
	//채권추심의뢰요청
	function select_collect_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					if(fm.cng_yn[idnum.substr(19)].value == 'N'){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'번은 채권추심 대상이 아닙니다.');
						ck.checked = false;
					}else{
						cnt++;
					}					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		if(!confirm('채권추심의뢰요청하면 채권담당자에게 채권추심이 요청되며,\n\n영업담당이 총무팀 채권담당자에게 넘어갑니다. 요청하시겠습니까?')){	return;	}		
		
		fm.target = "i_no";
		fm.action = "settle_acc_cng_req_a.jsp";
		fm.submit();	
	}			
	
	//채무자주소조회요청
	function select_addr_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "사용중인 계약과 해지된 계약을 한번에 요청할 수 없습니다." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//사용중인 계약과 해지된 계약을 한번에 요청할수 없습니다.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		//신분증상 주소로 내용증명 보내서 반송이 된 이력이 있어야만 조회가능 함 - 2021-02-09
		if(!confirm('채무자주소조회요청 하시겠습니까? \n\n팝업된 페이지에서 계약별 주소종류, 비고, 최고장종류, 유예기간 등을 입력하면 채권담당자에게 메시지가 갑니다.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_addr_req.jsp";
		fm.submit();	
	}					
	//운행정지명령신청요청
	function select_stop_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var j=0;
		
		var use_yn ="";
		var chk_yn ="";
		var result ="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					if(ck.name=="")
					idnum=ck.value;
					use_yn = document.inner.document.getElementById("use_yn"+j).value;
					if(!chk_yn){
						chk_yn = use_yn;
					}else{
						if(chk_yn != use_yn){
							result = "사용중인 계약과 해지된 계약을 한번에 요청할 수 없습니다." 			
						}
					}
					cnt++;					
				}
			j++;
			}
		}
		
		document.inner.document.getElementById("chk_yn").value = chk_yn;
		
		//사용중인 계약과 해지된 계약을 한번에 요청할수 없습니다.
		if(result){
			alert(result);
			return;
		}
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		if(!confirm('운행정지명령신청요청 하십겠습니까? \n\n팝업된 페이지에서 계약별 주소종류, 비고, 최고장종류, 유예기간 등을 입력하면 채권담당자에게 메시지가 갑니다.')){	return;	}		
		
		fm.target = "_blank";
		fm.action = "settle_acc_stop_req.jsp";
		fm.submit();	
	}					
	
	
	//채권대손처리요청
	function select_bad_debt_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					if(fm.bad_yn[idnum.substr(19)].value == 'N'){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'번은 채권 대손처리요청 대상이 아닙니다.');
						ck.checked = false;
					}else{
						cnt++;
					}					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("선택한 것이 없습니다.");
			return;
		}	
		if(cnt > 1){
		 	alert("1건만 선택하세요.");
			return;
		}	
		
//		if(!confirm('채권 대손처리요청하면 본사 총무팀장고객지원팀장에게 대손처리가 요청되며,\n\n영업담당이 변경됩니다. 요청하시겠습니까?')){	return;	}		
		
		fm.target = "d_content";
		fm.action = "settle_acc_bad_debt_doc_i.jsp";
		fm.submit();	
	}						
	
	//소액채권대손처리요청
	function settle_acc_bad_debt_req(req_st, m_id, l_cd, cls_use_mon, bad_amt, c_id, s_cd){
		var fm = document.form1;
		
		if(req_st != ''){
			if(!confirm('채권대손요청 기등록건입니다. 다시 요청하시겠습니까?')){	return;	}		
		} 
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.cls_use_mon.value = cls_use_mon;
		fm.bad_amt.value = bad_amt;
		fm.c_id.value = c_id;
		fm.s_cd.value = s_cd;
		fm.page_st.value = 'settle_acc';
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_debt_doc.jsp";
		fm.submit();
	}
		
	//고소장접수요청
	function settle_acc_bad_complaint_req(client_id){
		var fm = document.form1;
		fm.client_id.value = client_id;
		fm.page_st.value = 'settle_acc';
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_complaint_doc.jsp";
		fm.submit();
	}

	//고소장접수요청	
	function select_complaint_req(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var o_client_id="";		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					
					if(toInt(fm.fee_dly_mon[idnum.substr(19)].value) < 3){
						var list_num = toInt(idnum.substr(19))+1;
						alert(list_num+'번은 고소장접수요청 대상이 아닙니다.');
						ck.checked = false;
					}else{
						if(cnt > 0 && o_client_id != fm.client_id[idnum.substr(19)].value){							
							alert('같은 고객만 묶어 요청할수 있습니다.');
							return;							
						}else{
							cnt++;
						}
					}
					o_client_id = fm.client_id[idnum.substr(19)].value;
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		fm.o_client_id.value = o_client_id;		
		fm.target = "d_content";		
		fm.action = "/fms2/settle_acc/bad_complaint_doc.jsp";
		fm.submit();	
	}
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='s_cd' value=''>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cls_use_mon' value=''>
<input type='hidden' name='bad_amt' value=''>
<input type='hidden' name='page_st' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='today' value='<%=today%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='s_height' value='<%=s_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
		        <tr>
    				<td align='center'>
    				  <iframe src="/acar/settle_acc/settle_sc_in.jsp?auth_rw=<%=auth_rw%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="inner" width="100%" height="<%=height - 10%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
    				  </iframe>
    				</td>
		        </tr>
	        </table>
        </td>
    </tr>
    <tr>
        <td>
		<a href="javascript:select_credit_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='내용증명발송요청'><img src="/acar/images/center/button_yc_nyjmbs.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;
		<a href="javascript:select_collect_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='채권추심의뢰요청'><img src="/acar/images/center/button_ask_cgcs.gif" align="absmiddle" border="0"></a>					
		&nbsp;&nbsp;
		<a href="javascript:select_addr_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='채무자주소조회요청'><img src="/acar/images/center/button_ask_add.png" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;
		<a href="javascript:select_stop_req();" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='운행정지명령요청'><img src="/acar/images/center/button_ask_stop.png" align="absmiddle" border="0"></a>
		&nbsp;(채권담당자에게 업무협조로 등록되며, 메세지가가 발송됩니다. <a href="javascript:view_credit_req()" title="이력"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>)
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>      		
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" class='title' align="center">구분</td>
                    <td colspan="2" class='title' align="center">합계</td>
                    <td colspan="2" class='title' align="center">선수금</td>
                    <td colspan="2" class='title' align="center">대여료</td>
                    <td colspan="2" class='title' align="center">연체이자</td>					
                    <td colspan="2" class='title' align="center">과태료</td>
                    <td colspan="2" class='title' align="center">면책금</td>
                    <td colspan="2" class='title' align="center">휴/대차료</td>
                    <td colspan="2" class='title' align="center">해지정산금</td>
                    <td colspan="2" class='title' align="center">단기요금</td>			
                </tr>
                <tr align="center"> 
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                    <td class='title'>건수</td>
                    <td class='title'>금액</td>
                </tr>
                <tr> 
                    <td rowspan="2" class='title'>실제</td>				
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="10" class="whitenum2">원&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">건&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="8" class="whitenum2">원&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="10" class="whitenum2">원&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="10" class="whitenum2">원&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="7" class="whitenum2">원&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="9" class="whitenum2">원&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="1" class="whitenum2">건&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="9" class="whitenum2">원&nbsp;</td>
                    <td align="right"><input type="text" name="cnt" size="2" class="whitenum2">건&nbsp;</td>
                    <td align="right"><input type="text" name="amt" size="10" class="whitenum2">원&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="cnt" size="1" class="whitenum2">건&nbsp;</td>
                    <td rowspan="2" align="right"><input type="text" name="amt" size="8" class="whitenum2">원&nbsp;</td>
                </tr>
                <tr>
                  <td align="right"><input type="text" name="e_cnt" size="2" class="whitenum2">건&nbsp;</td>
                  <td align="right"><input type="text" name="e_amt" size="10" class="whitenum2">원&nbsp;<br>(승계수수료)</td>
                  <td align="right"><input type="text" name="in_cnt" size="2" class="whitenum2">건&nbsp;</td>
                  <td align="right"><input type="text" name="in_amt" size="10" class="whitenum2">원&nbsp;<br>(회수)</td>
                  <td align="right"><input type="text" name="h_cnt" size="2" class="whitenum2">건&nbsp;</td>
                  <td align="right"><input type="text" name="h_amt" size="10" class="whitenum2">원&nbsp;<br>(경감)</td>
                  <td align="right"><input type="text" name="g_cnt" size="2" class="whitenum2">건&nbsp;</td>
                  <td align="right"><input type="text" name="g_amt" size="10" class="whitenum2">원&nbsp;<br>(보험)</td>
                </tr>
                <tr>
				  <td class='title'>반영</td>		
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="8" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="7" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="9" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="9" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="2" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="10" class="isnum2">원&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="cnt" size="1" class="isnum2">건&nbsp;</td>
                  <td align="right" class="is"><input type="text" name="amt" size="8" class="isnum2">원&nbsp;</td>
                </tr>
                <tr>
                  <td class='title'>비고</td>
                  <td colspan="2" align="right">&nbsp;</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%<br>승계수수료*3배반영</td>
                  <td colspan="2" align="center" style='font-size:8pt'>회수차량은 채권10% 반영<br>미청구분 3일경과부터 반영<br>월렌트 마감당일 제외</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>				  
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>
                  <td colspan="2" align="center" style='font-size:8pt'>100%</td>
                  <td colspan="2" align="center" style='font-size:8pt'><!--청구일+5일까지 경감<br>입금일+10일까지 경감<br>미입금시 최대30일반영-->입금일+1개월<br>1군50%/2군25%경감반영</td>
                  <td colspan="2" align="center" style='font-size:8pt'>보증보험청구분 경감<br>100만원이하100%<br>초과시100만원+초과20%반영</td>
                  <td colspan="2" align="center" style='font-size:8pt'>초회 최초영업100%<br>그외 최초영업20%/관리담당80%</td>
                </tr>
            </table>
        </td>
    </tr>	  
    <tr>
        <td>&nbsp;*  반영 : 채권캠페인 실반영분입니다. <%if(gubun3.equals("5")){%>(연체이자를 제외한 리스트입니다. 전체는 [세부조회-미수금전체]로 검색하십시오.)<%}%>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
