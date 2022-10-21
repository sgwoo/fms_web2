<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.secondhand.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);
	
	//예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
	
	int use_cnt = 0;
	
	Vector sr = shDb.getShResList(c_id);
	int sr_size = sr.size();
	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;		
		var brch_id = fm.brch_id.value;
		var start_dt = fm.start_dt.value;
		var end_dt = fm.end_dt.value;				
		var car_comp_id = fm.car_comp_id.value;				
		var code = fm.code.value;				
		var s_cc 	= fm.s_cc.value;
		var s_year 	= fm.s_year.value;				
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/acar/res_search/res_se_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&start_dt="+start_dt+"&end_dt="+end_dt+"&car_comp_id="+car_comp_id+"&code="+code+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
	function reservation(){
		var fm = document.form1;
		fm.rent_start_dt.value 	= fm.rent_start_dt_y.value+fm.rent_start_dt_m.value+fm.rent_start_dt_d.value;
		fm.rent_end_dt.value 	= fm.rent_end_dt_y.value+fm.rent_end_dt_m.value+fm.rent_end_dt_d.value;	
		if(fm.rent_start_dt.value == ''){ alert("대여개시일이 없습니다. 날짜를 선택하십시오."); return; }		
//		if(fm.rent_end_dt.value == '' && fm.rent_st.value == '1'){ alert("대여만료일을 입력하십시오."); return; }
		if(fm.rent_end_dt.value != '' && fm.rent_start_dt.value > fm.rent_end_dt.value){ alert("대여만료일이 대여개시일 보다 작습니다. 확인하십시오."); return; }	
		
		if(toInt(fm.use_cnt.value) > 0 && !confirm('예약 혹은 배차중에 있는 차량입니다.\n\n예약하시겠습니까?')){	return;	}
					
		fm.action = "/acar/res_search/res_rent_i.jsp";
		fm.target = "d_content";
		fm.submit();
		self.close();
	}	

	function CarRentSearch(car_no) {
		var keyValue = event.keyCode;	
		if (keyValue =='13'){
			var SUBWIN="./car_rent_list.jsp?gubun=car_no&rent_l_cd=&firm_nm=&car_no="+car_no;	
			window.open(SUBWIN, "CarRentList", "left=100, top=100, width=700, height=400, scrollbars=yes");
		}
		return;
	}	
	
	function ReLoadRes(c_id){
		var fm = document.form1;
		fm.c_id.value = c_id;
		fm.action = "car_res_list.jsp";
		fm.submit();
	}

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=&rent_l_cd=&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}			
</script>
</head>
<body leftmargin="15">

<form name="form1" method="post" action="res_rent_i.jsp">
<input type='hidden' name='c_id' value='<%=c_id%>'>
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
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' value='<%=asc%>'> 
 <input type='hidden' name='rent_start_dt' value=''>
 <input type='hidden' name='rent_end_dt' value=''>
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예약조회 > <span class=style5>차량별 예약/대여 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="13%">차량번호</td>
                    <td> 
                      &nbsp;<input type="text" name="car_no" size="10" value="<%=res.get("CAR_NO")%>" class='text' onKeydown="CarRentSearch(this.value)">
                    </td>
                    <td class=title>차명</td>
                    <td align="left" colspan="3">&nbsp;<%=res.get("CAR_NM")%>&nbsp;<%=res.get("CAR_NAME")%></td>
                    <td class=title width="13%">차대번호</td>
                    <td align="left" colspan="3">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=res.get("CAR_NUM")%></a></td>
                </tr>
                <tr> 
                    <td class=title width=10%>최초등록일</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("INIT_REG_DT")))%></td>
                    <td class=title width=8%>출고일자</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("DLV_DT")))%></td>
                    <td class=title width=14%>배기량</td>
                    <td width=8%>&nbsp;<%=res.get("DPM")%>cc</td>
                    <td class=title width=10%>칼라</td>
                    <td width=10%>&nbsp;<%=res.get("COLO")%></td>
                    <td class=title width=6%>연료</td>
                    <td width=13%>&nbsp;<%=res.get("FUEL_KD")%></td>
                </tr>
                <tr> 
                    <td class=title>선택사양</td>
                    <td colspan="3">&nbsp;<%=res.get("OPT")%></td>
                    <td class=title>현재예상주행거리</td>
                    <td>&nbsp;<%=Util.parseDecimal(String.valueOf(res.get("TODAY_DIST")))%>km</td>
                    <td class=title>최종점검일</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(res.get("SERV_DT")))%></td>
                </tr>
				<tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=23% colspan="3">&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_ST_DT")))%>" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("MAINT_END_DT")))%>" size="10" class=whitetext>
                      &nbsp; </td>
                    <td class=title>차령만료일</td>
                    <td>&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("CAR_END_DT")))%>" size="10" class=whitetext>
                    </td>
                    <td class=title>점검유효기간</td>
                    <td colspan="3">&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_ST_DT")))%>" size="10" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(res.get("TEST_END_DT")))%>" size="10" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td height="21" align="right"><!--<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
	<%if(1!=1){%>
    <tr> 
        <td>
            <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white cellpadding=5 width="100%" bordercolorlight=#8f8f8f border=1>
                <tbody> 
                <tr align="center"> 
                    <td width="50"> 
                      <p>구분</p>
                    </td>
                    <td width="90"> 
                      <select name="rent_st">
                        <option value="1" <%if(rent_st.equals("1"))%>selected<%%>>단기대여</option>
                        <option value="2" <%if(rent_st.equals("2"))%>selected<%%>>정비대차</option>
                        <option value="3" <%if(rent_st.equals("3"))%>selected<%%>>사고대차</option>
                        <option value="9" <%if(rent_st.equals("9"))%>selected<%%>>보험대차</option>
                        <option value="10" <%if(rent_st.equals("10"))%>selected<%%>>지연대차</option>
                        <option value="4" <%if(rent_st.equals("4"))%>selected<%%>>업무대여</option>
        <!--            <option value="5" <%if(rent_st.equals("5"))%>selected<%%>>업무지원</option>-->
                        <option value="6" <%if(rent_st.equals("6"))%>selected<%%>>차량정비</option>
        <!--            <option value="7" <%if(rent_st.equals("7"))%>selected<%%>>차량점검</option>-->
                        <option value="8" <%if(rent_st.equals("8"))%>selected<%%>>사고수리</option>
                        <option value="11" <%if(rent_st.equals("11"))%>selected<%%>>장기대기</option>
                        <option value="12" <%if(rent_st.equals("12"))%>selected<%%>>월렌트</option>
                      </select>
                    </td>
                    <td width="60">대여기간</td>
                    <td> 
                      <select name="rent_start_dt_y">
                        <%for(int i=AddUtil.getDate2(1); i<AddUtil.getDate2(1)+2; i++){%>
                        <option value="<%=i%>"><%=i%>년</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_m">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate2(2)==i)%>selected<%%>><%=AddUtil.addZero2(i)%>월</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_d">
                        <%for(int i=1; i<=31; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate2(3)==i)%>selected<%%>><%=AddUtil.addZero2(i)%>일</option>
                        <%}%>
                      </select>
                      ~ 			  
                      <select name="rent_end_dt_y">
        			  <option value="">선택</option>		
                        <%for(int i=AddUtil.getDate2(1); i<AddUtil.getDate2(1)+2; i++){%>
                        <option value="<%=i%>"><%=i%>년</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_m">
        			  <option value="">선택</option>		
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>월</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_d">
        			  <option value="">선택</option>		
                        <%for(int i=1; i<=31; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>일</option>
                        <%}%>
                      </select>
        			  <!--			
                      <input type="text" name="rent_start_dt" size="10" readonly value="<%=rent_start_dt%>">
                      ~ 
                      <input type="text" name="rent_end_dt" size="10" readonly value="<%=rent_end_dt%>">
        			  -->
                    </td>
                    <td width="90">
        	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  			
        			<a href="javascript:reservation();" onFocus="this.blur()"><img src="/images/reservation.gif" border=0 width="88" height="27"></a></td>
        	  	<%}else{%>&nbsp;<%}%>						
                </tr>
                </tbody> 
            </table>
        </td>
    </tr>	
    <tr> 
        <td>&nbsp;</td>
    </tr>	
	<%}%>		
	<%if(sr_size>0){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재리스 차량예약</span></td>
    <tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
				<%	for(int i = 0 ; i < 1 ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td class="title" width="10%">구분</td>					
                    <td align="center" width="10%"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("상담중");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("계약확정");  %></td>										
                    <td class="title" width="10%">예약기간</td>					
                    <td align="center" width="20%"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %></td>															
                    <td class="title" width="10%">담당자</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>															
                    <td class="title" width="10%">메모</td>
                    <td width="20%"><%=sr_ht.get("MEMO")%></td>															
                </tr>						
				<%}%>
            </table>
	    </td>
    </tr>	
	<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운행 이력</span></td>
    <tr>			
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan='2' width="4%">연번</td>
                    <td class=title rowspan='2' width="7%">구분</td>
                    <td class=title rowspan='2' width="4%">상태</td>
                    <td class=title colspan='2'>자동차</td>										
                    <td class=title rowspan='2' width="18%">대여기간</td>
                    <td class=title rowspan='2' width="24%">상호/성명</td>					
                    <td class=title rowspan='2' width="7%">담당자</td>					
                    <td class=title rowspan='2' width="10%">등록일자</td>
                    <td class=title rowspan='2' width="6%">스케줄</td>			
                </tr>
				<tr>
                    <td class=title width="10%">보유차</td>														
                    <td class=title width="10%">사유발생</td>																			
				</tr>			
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);
    					if(String.valueOf(reservs.get("USE_ST")).equals("예약") || String.valueOf(reservs.get("USE_ST")).equals("배차")) use_cnt ++;
    					%>
                <tr> 
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center"><%=i+1%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center"><%=reservs.get("RENT_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center"><%=reservs.get("USE_ST")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_p"<%%> align="center"><%=reservs.get("CAR_NO")%></td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_p"<%%> align="center"><%=reservs.get("D_CAR_NO")%></td>															
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>시<br> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>시</td>
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center"><a class=index1 href="javascript:MM_openBrWindow('rent_cont.jsp?c_id=<%=c_id%>&s_cd=<%=reservs.get("RENT_S_CD")%>&car_no=<%=res.get("CAR_NO")%>','RentCont','scrollbars=yes,status=yes,resizable=yes,width=850,height=800,left=10, top=10')"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></a></td>
                    <!--<td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_p"<%%> align="center"><%=AddUtil.parseDecimal(String.valueOf(reservs.get("FEE_AMT")))%></td>-->
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_p"<%%> align="center"><%=reservs.get("BUS_NM")%></td>					
                    <td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_p"<%%> align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs.get("REG_DT")))%></td>										
        			<td <%if(!String.valueOf(reservs.get("USE_ST")).equals("예약")&&!String.valueOf(reservs.get("USE_ST")).equals("배차"))%>class="title_pn"<%%> align="center">
					<%if(!String.valueOf(reservs.get("USE_ST")).equals("취소")){%>
					<a class=index1 href="javascript:MM_openBrWindow('car_scd_add.jsp?c_id=<%=c_id%>&s_cd=<%=reservs.get("RENT_S_CD")%>&car_no=<%=res.get("CAR_NO")%>','ImgAdd','scrollbars=yes,status=yes,resizable=yes,width=620,height=600,left=50, top=50')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					<%}else{%>-<%}%>
					</td>			
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='10' align='center'>등록된 데이타가 없습니다</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
	<!--
    <tr> 
      <td>&lt; 예약가능 날짜 조회&gt;</td>
    </tr>	
    <tr> 
      <td>
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
  		  <tr>
    		<td><iframe src="/acar/res_search/calendar_s.jsp?c_id=<%=c_id%>" name="inner_s" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
    		<td><iframe src="/acar/res_search/calendar_e.jsp?c_id=<%=c_id%>" name="inner_e" width="300" height="290" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        	</iframe></td>
  		  </tr>
		</table>
	  </td>
    </tr>
	-->	
</table>
<input type='hidden' name='use_cnt' value='<%=use_cnt%>'>  
</form>
</body>
</html>
