<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
//	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
	
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "04", "01");
		
	Hashtable ht =  rs_db.getStatCar3(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc, cjgubun);
		
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
	
//	out.println(height);
	if ( height < 300) height =300;
	
	if ( first.equals("Y")) return; 
		
%>	

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_car(s_cd, c_id){
		var fm = document.form1;
		fm.action = '/acar/res_search/car_res_list.jsp';
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
		fm.submit();
	}
	
	//차량예약현황 조회
	function car_reserve(s_cd, c_id){
		var fm = document.form1;
		fm.c_id.value = c_id;		
		var SUBWIN="/acar/rent_diary/car_res_list.jsp?c_id="+fm.c_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=850, height=600, scrollbars=yes, status=yes");
	}
	
 	//매각예정&보류차량 처리
	function prepare_action(mode){
		var fm = inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'pr'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}	
		if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	
		if(mode == '2'){ 	if(!confirm('매각예정처리를 하시겠습니까?')){	return;	}}
		if(mode == '3'){ 	if(!confirm('보류차량처리를 하시겠습니까?')){	return;	}}		
		if(mode == '4'){ 	if(!confirm('말소차량처리를 하시겠습니까?')){	return;	}}				
		if(mode == '5'){ 	if(!confirm('도난차량처리를 하시겠습니까?')){	return;	}}				
		if(mode == '6'){ 	if(!confirm('해지처리를 하시겠습니까?')){		return;	}}								
		
		fm.mode.value = mode;
		fm.action = "rent_pr_set.jsp";
		fm.target = "i_no";		
		fm.submit();
	}
	
 	//오프리스구분
	function off_ls_action(mode){
		var fm = inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'pr'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}	
		if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	
		
		<%if(nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
		if(mode == '1'){ 	if(!confirm('매각결정처리를 하시겠습니까?')){	return;	}}
		fm.mode.value = mode;
		fm.action = "rent_ol_set.jsp";
		fm.target = "i_no";
		fm.submit();
		<%}else{%>
		alert("귀하는 매각결정처리를 하실 권한이 없습니다. 매각결정처리 권한은  고객지원팀장님만 있습니다.");
		return;
		<%}%>
	}	
//-->
</script>
</head>
<body leftmargin="15">
  <form name='form1' method='post' target='d_content'>
    <input type='hidden' name='s_cd' value=''>
    <input type='hidden' name='c_id' value=''>
    <input type='hidden' name='rent_st' value=''>
    <input type='hidden' name='rent_start_dt' value=''>
    <input type='hidden' name='rent_end_dt' value=''>
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
    <input type='hidden' name='gubun1' value='<%=gubun1%>'>
    <input type='hidden' name='gubun2' value='<%=gubun2%>'>
    <input type='hidden' name='brch_id' value='<%=brch_id%>'>
    <input type='hidden' name='start_dt' value='<%=start_dt%>'>
    <input type='hidden' name='end_dt' value='<%=end_dt%>'>
    <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
    <input type='hidden' name='code' value='<%=code%>'>
    <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' value='<%=t_wd%>'>
    <input type='hidden' name='s_cc' value='<%=s_cc%>'>
    <input type='hidden' name='s_year' value='<%=s_year%>'>
    <input type='hidden' name='sort_gubun' value="<%=sort_gubun%>">
    <input type='hidden' name='asc' value='<%=asc%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>

  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align="right" colspan="2">
        * 평균가동율:
        [본사]<input type='text' name='s1_use_avg_per' size='3' class='whitenum'>%&nbsp;
        [부산]<input type='text' name='b1_use_avg_per' size='3' class='whitenum'>%&nbsp;
        [대전]<input type='text' name='d1_use_avg_per' size='3' class='whitenum'>%&nbsp;
		[광주]<input type='text' name='j1_use_avg_per' size='3' class='whitenum'>%&nbsp;
		[대구]<input type='text' name='g1_use_avg_per' size='3' class='whitenum'>%&nbsp;
		&nbsp;&nbsp;(단기대여,정비대차는 vat포함금액)&nbsp;
<%	if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보유차관리자들",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("지점장",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) ||user_id.equals("000048")){%>
        
    	<a href="javascript:prepare_action('1');" title='예비차량처리'><img src="/acar/images/center/button_ybcrcr.gif" align="absmiddle" border="0"></a>&nbsp;
    	<a href="javascript:prepare_action('2');" title='매각예정처리'><img src="/acar/images/center/button_mgyjcr.gif" align="absmiddle" border="0"></a>&nbsp;
    	<a href="javascript:off_ls_action('1');" title='매각결정처리'><img src="/acar/images/center/button_mg_gjcr.gif" align="absmiddle" border="0"></a>&nbsp;		
    	<!--<a href="javascript:prepare_action('6');"><img src="/acar/images/center/button_hjcr.gif" align="absmiddle" border="0"></a>&nbsp;-->
    	<a href="javascript:prepare_action('5');" title='도난처리'><img src="/acar/images/center/button_dncr.gif" align="absmiddle" border="0"></a>&nbsp;
    	<a href="javascript:prepare_action('4');" title='말소처리'><img src="/acar/images/center/button_mscr.gif" align="absmiddle" border="0"></a>&nbsp;
    	<a href="javascript:prepare_action('8');" title='수해'><img src="/acar/images/center/button_shae.gif" align="absmiddle" border="0"></a>	
        <!--&nbsp;&nbsp;<a href="javascript:prepare_action('3');">보관차량처리</a>-->
<%	}%>          
        </td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan='3'> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> <iframe src="rent_pr_sc_in.jsp?first=<%=first%>&height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&sh_height=<%=sh_height%>&cjgubun=<%=cjgubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td width='100'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차 통계</span></td>
        <td align="right">
	  	    <font color="#999999">* 차량번호
		    <font color="#ff8200"><b>주황색</b></font>은 수해경력 표시, <font color="green"><b>녹색</b></font>은 매각검토차량으로 분류된 차량 표시,
		    <img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_memo.gif"  align="absmiddle" border="0"> 클릭시 주차장현황 확인 가능,
		    현위치 옆 P는 주차장 입고일때 표시,
		    구분 옆 S는 재리스등록차량 표시.
		    &nbsp;&nbsp; * 가동율 계산기준 : 3주이내
		    </font></td>
        <td width='17'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width="10%" rowspan="3" class='title'>구분</td>                
                    <td class='title' colspan="12">예비차량</td>
                    <td width="6%" rowspan="3" class='title'>매각<br>예정</td>
                    <td width="6%" rowspan="3" class='title'>합계</td>
                </tr>
                <tr> 
                    <td class='title' colspan="7">정상운행</td>
                    <td class='title' colspan="4">휴차</td>
                    <td class='title' rowspan="2" width="6%">계</td>
                </tr>
                <tr> 
                    <td width="7%" class='title'>월렌트</td>
                    <td width="7%" class='title'>단기대여</td>
                    <td width="6%" class='title'>보험대차</td>
                    <td width="7%" class='title'>지연대차</td>
                    <td width="7%" class='title'>정비대차</td>
                    <td width="7%" class='title'>사고대차</td>
                    <td width="7%" class='title'>업무대여</td>
                    <td width="6%" class='title'>대기</td>
                    <td width="6%" class='title'>예약</td>
                    <td width="6%" class='title'>차량정비</td>
                    <td width="6%" class='title'>사고수리</td>
                </tr>
                <tr align="center"> 
                    <td class='title'>상태</td>                
                    <td><%=ht.get("CNT12")%><!--월렌트--></td>
                    <td><%=ht.get("CNT0")%><!--단기대여--></td>
                    <td><%=ht.get("CNT1")%><!--보험대차--></td>
                    <td><%=ht.get("CNT2")%><!--지연대차--></td>
                    <td><%=ht.get("CNT3")%><!--정비대차--></td>
                    <td><%=ht.get("CNT4")%><!--사고대차--></td>
                    <td><%=ht.get("CNT5")%><!--업무대여--></td>
                    <td><%=ht.get("CNT9")%><!--대기--></td>
                    <td><%=ht.get("CNT8")%><!--예약--></td>					
                    <td><%=ht.get("CNT6")%><!--차량정비--></td>
                    <td><%=ht.get("CNT7")%><!--사고수리--></td>    
                    <!--예비차량 소계-->  
                    <td><%=AddUtil.parseInt(String.valueOf(ht.get("CNT12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT9")))%></td>
                    <td><%=ht.get("CNT11")%><!--매각예정--></td>
                    <!--전체 합계-->
                    <td><%=AddUtil.parseInt(String.valueOf(ht.get("CNT12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT9")))+AddUtil.parseInt(String.valueOf(ht.get("CNT11")))%></td>
                </tr>
                <tr align="center"> 
                    <td class='title'>계약확정/상담</td>                
                    <td><%=ht.get("CNT1_12")%>/<%=ht.get("CNT2_12")%><!--월렌트--></td>
                    <td><%=ht.get("CNT1_0")%>/<%=ht.get("CNT2_0")%><!--단기대여--></td>
                    <td><%=ht.get("CNT1_1")%>/<%=ht.get("CNT2_1")%><!--보험대차--></td>
                    <td><%=ht.get("CNT1_2")%>/<%=ht.get("CNT2_2")%><!--지연대차--></td>
                    <td><%=ht.get("CNT1_3")%>/<%=ht.get("CNT2_3")%><!--정비대차--></td>
                    <td><%=ht.get("CNT1_4")%>/<%=ht.get("CNT2_4")%><!--사고대차--></td>
                    <td><%=ht.get("CNT1_5")%>/<%=ht.get("CNT2_5")%><!--업무대여--></td>
                    <td><%=ht.get("CNT1_9")%>/<%=ht.get("CNT2_9")%><!--대기--></td>					
                    <td><%=ht.get("CNT1_8")%>/<%=ht.get("CNT2_8")%><!--예약--></td>
                    <td><%=ht.get("CNT1_6")%>/<%=ht.get("CNT2_6")%><!--차량정비--></td>
                    <td><%=ht.get("CNT1_7")%>/<%=ht.get("CNT2_7")%><!--사고수리--></td>      
                    <!--예비차량 소계-->  
                    <td>
                      <%=AddUtil.parseInt(String.valueOf(ht.get("CNT1_12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_9")))%>/
                      <%=AddUtil.parseInt(String.valueOf(ht.get("CNT2_12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_9")))%>
                    </td>
                    <td><%=ht.get("CNT1_11")%>/<%=ht.get("CNT2_11")%><!--매각예정--></td>
                    <!--전체 합계-->
                    <td>
                      <%=AddUtil.parseInt(String.valueOf(ht.get("CNT1_12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_9")))+AddUtil.parseInt(String.valueOf(ht.get("CNT1_11")))%>/
                      <%=AddUtil.parseInt(String.valueOf(ht.get("CNT2_12")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_0")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_1")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_2")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_5")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_6")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_7")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_8")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_9")))+AddUtil.parseInt(String.valueOf(ht.get("CNT2_11")))%>
                    </td>
                </tr>                
            </table>
        </td>
        <td width=17>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>
