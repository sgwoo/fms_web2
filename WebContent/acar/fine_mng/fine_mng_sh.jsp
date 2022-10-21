<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.forfeit_mng.*, acar.common.*, acar.user_mng.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//기본정보
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	
	if(!c_id.equals("")){//값이 있을때 검색한다.
		rl_bean = fdb.getCarRent(c_id, m_id, l_cd);
	}


	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);


	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?from_page="+from_page+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_ts.css">
</head>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//계약번호, 상호, 차량번호로 계약 조회
	function CarRentSearch(arg){
		var fm = document.form1;
		var l_cd = "";
		var firm_nm = "";
		var car_no = "";
		var keyValue = event.keyCode;
		
		
		if (keyValue =='13'){
			if(arg=="rent_l_cd"){
				l_cd = fm.l_cd.value;
				if(l_cd == '') { alert('계약번호를 확인하십시오.'); return; }
				var SUBWIN="./car_rent_list.jsp?gubun="+arg+"&l_cd="+l_cd+"&firm_nm="+firm_nm+"&car_no="+car_no;	
				window.open(SUBWIN, "CarRentList", "left=100, top=100, width=1020, height=500, scrollbars=yes");
			}else if(arg=="firm_nm"){
				firm_nm = fm.firm_nm.value;
				if(firm_nm == '') { alert('상호를 확인하십시오.'); return; }
				var SUBWIN="./car_rent_list.jsp?gubun="+arg+"&l_cd="+l_cd+"&firm_nm="+firm_nm+"&car_no="+car_no;	
				window.open(SUBWIN, "CarRentList", "left=100, top=100, width=1020, height=500, scrollbars=yes");
			}else if(arg=="car_no"){
				car_no = fm.car_no.value;
				if(car_no == '') { alert('차량번호를 확인하십시오.'); return; }
				CarRentSearch2();
			}
		}
	}
	
	//차량번호로 계약 조회
	function CarRentSearch2(){
		var fm = document.form1;		
		var SUBWIN="./search_cont.jsp?car_no="+fm.car_no.value;	
		window.open(SUBWIN, "FineSearchCont", "left=10, top=10, width=1500, height=600, scrollbars=yes");
	}	

	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=820, height=700, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=600, scrollbars=yes");			
	}			
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//리로드하기-다른과태료 보기
	function fine_mng_sc_go(seq_no){
		var fm = document.form1;
		fm.seq_no.value = seq_no;
		fm.target = "c_foot";
		fm.action = "fine_mng_sc.jsp";
		fm.submit();
	}	
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var gubun5 	= fm.gubun5.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		
		if ( fm.from_page.value == ''){
			if(fm.f_list.value == 'in'){
				parent.location = "/acar/con_forfeit/forfeit_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
			}else if(fm.f_list.value == 'non'){
				parent.location = "/acar/forfeit_mng/forfeit_n_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
			}else{
				parent.location = "/acar/forfeit_mng/forfeit_s_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
			}
		} else {
				parent.location = fm.from_page.value+"?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		
		}	
	}		
	//청구메모등록
	function reg_fineMm(){
		var fm = document.form1;		
		fm.action='fine_mm_a.jsp';
		fm.target='i_no';
		fm.submit();
	}

	//엑셀 
	function pop_excel(){
		var fm = document.form1;	
		fm.target = "_blank";
		fm.action = "/acar/forfeit_mng/case_excel.jsp";
		fm.submit();
	}		
	
	//수정
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=600, status=yes, scrollbars=yes");
		}else{
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=600, status=yes, scrollbars=yes");
		}
	}
	
	//차량이력
	function car_history(){
		var fm = document.form1;	
		if(fm.car_no.value == '') { alert('차량번호를 확인하십시오.'); return; }
		window.open("/acar/off_lease/off_lease_car_his.jsp?car_mng_id=<%=c_id%>&from_page=/acar/fine_mng/fine_mng_sh.jsp", "VIEW_CAR_H", "left=10, top=10, width=900, height=600, scrollbars=yes");		
	}			
	
	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	function moveOcr() {
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "../fine/fine_ocr_frame.jsp";
		fm.submit();
	}
	
	$(document).ready(function(){
		// 상호가 아마존카인지 확인하여 아마존카인 경우 보유차 확인 메시지 출력
		if($("#firm_nm").val() == "(주)아마존카") {
			alert("보유차입니다. 하단의 보유차 운행현황을 선택하세요.");
		}
	});
//-->
</script>

<body onLoad="javascript:document.form1.car_no.focus()">
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="mode" value="<%=mode%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 과태료관리 > <span class=style5>등록/수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<input type="text" name="l_cd" size="18" value="<%=rl_bean.getRent_l_cd()%>" class=text onKeydown="CarRentSearch('rent_l_cd')"  style='IME-MODE: inactive'> 
                    </td>
                    <td class=title>계약자</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=rl_bean.getRent_mng_id()%>', '<%=rl_bean.getRent_l_cd()%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=rl_bean.getClient_nm()%></a></td>
                    <td class=title>상호</td>
                    <td colspan="3">&nbsp;<input type="text" name="firm_nm" size="52" value="<%=rl_bean.getFirm_nm()%>" class=text onKeydown="CarRentSearch('firm_nm')"  style='IME-MODE: active'> 
                    </td>
                </tr>
                <tr> 
                    <td width=10% class=title>차량번호</td>
                    <td width=17%>&nbsp;<input type="text" name="car_no" size="14" value="<%=rl_bean.getCar_no()%>" class=text onKeydown="CarRentSearch('car_no')" style="ime-mode:active;" >
					  <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
					  <a href="javascript:car_history()" title="차량이력표"><img src=/acar/images/center/button_in_usecar.gif align=absmiddle border=0></a>
					  <%}%>					  				  
					</td>
                    <td width=10% class=title>차종</td>
                    <td width=16% align="left">&nbsp;<a href="javascript:view_car('<%=rl_bean.getRent_mng_id()%>', '<%=rl_bean.getRent_l_cd()%>', '<%=rl_bean.getCar_mng_id()%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=rl_bean.getCar_nm()%></a> </td>
                    <td width=10% class=title>대여방식</td>
                    <td width=13% align="left">&nbsp;<%=rl_bean.getRent_way_nm()%> </td>
                    <td width=10% class=title>대여기간</td>
                    <td width=14% align="left">&nbsp;<%=rl_bean.getCon_mon()%> 개월</td>
                </tr>
                <tr> 
                    <td class=title>계약서스캔</td>
                    <td>&nbsp; 
					  <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
                      <%if(!c_id.equals("")){%>
                      <%if(!rl_bean.getScan_file().equals("")){%>
                      <a href="javascript:view_scan('<%=m_id%>','<%=l_cd%>')" onMouseOver="window.status=''; return true" title="스캔파일 보기"><img src=/acar/images/center/button_in_gys.gif align=absmiddle border=0></a> 
                      <%}else{%>
                      <a href="javascript:view_scan('<%=m_id%>','<%=l_cd%>')" onMouseOver="window.status=''; return true" title="스캔파일 보기"><img src=/acar/images/center/button_in_scan.gif align=absmiddle border=0></a> 
        			  (<%=rl_bean.getCar_doc_no()%>)
                      <%}%>
                      <%}else{%>
                      - 
                      <%}%>
					  <%}%>
                    </td>
                    <td class=title>연락처</td>
                    <td align="left">&nbsp;<%=rl_bean.getO_tel()%> </td>
                    <td class=title>팩스</td>
                    <td align="left">&nbsp;<%=rl_bean.getFax()%> </td>
                    <td class=title>대여개시일</td>
                    <td align="left">&nbsp;<%=rl_bean.getRent_start_dt()%> </td>
                    
                </tr>
                <tr> 
                    <td class=title>청구메모</td>
                    <td colspan="5">&nbsp;<textarea rows='1' cols='75' name='fine_mm' class='p'><%=rl_bean.getFine_mm()%></textarea>&nbsp;<a href="javascript:reg_fineMm()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td class=title>영업담당</td>
                    <td align="left">&nbsp;<%=c_db.getNameById(rl_bean.getBus_id2(),"USER")%><%//=rl_bean.getBus_id2()%>
					  <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
					  <a href="javascript:update('bus_id2')" title="담당이력"><img src=/acar/images/center/button_in_ddir.gif align=absmiddle border=0></a>
					  <%}%>
					</td>
					  <tr> 
                    <td class=title>우편물주소</td>
                    <td colspan="5">&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:update('client')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                                   
                    </td>
                    <td class=title>우편물수취인</td>
                    <td align="left">&nbsp;<%=base.getTax_agnt()%></td>
                </tr>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>위반리스트</span><input type="button" class="button btn-submit" value="OCR리스트" style="margin-left: 1%;" onclick="moveOcr()"></td>
        <td align="right">
		<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
		  <a href="javascript:view_memo('<%=m_id%>','<%=l_cd%>');" class="btn"><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>
          &nbsp;
	      <a href="javascript:pop_excel();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
		  <%if(!mode.equals("view")){%>
	      &nbsp;<a href="javascript:go_to_list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
		  <%}%>  
		<%}%>  
		</td>
    </tr>
    <tr>
	    <td colspan="2">
    		<table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        			<td>
        			  <iframe src="fine_list_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&f_list=<%=f_list%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&mode=<%=mode%>&rent_st=<%=rent_st%>" name="ForFeitList" width="100%" height="158" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        			</td>
    		    </tr>
    		</table>
	    </td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
