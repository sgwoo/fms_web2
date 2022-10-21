<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*, acar.common.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
		
	int count = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "06");
	
	String car_no = "";
	String r_m_id = "";
	String r_l_cd = "";

	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//등록하기
	function doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.off_id.value 	= sh_fm.off_id.value;
		fm.off_nm.value 	= sh_fm.off_nm.value;				
		fm.req_id.value 	= sh_fm.req_id.value;
		fm.cmp_app.value 	= sh_fm.cmp_app.value;				
		fm.cons_cau.value 	= sh_fm.cons_cau.value;
		fm.cons_cau_etc.value 	= sh_fm.cons_cau_etc.value;				
		fm.cost_st.value 	= sh_fm.cost_st.value;
		fm.pay_st.value 	= sh_fm.pay_st.value;				
		fm.etc.value 	= sh_fm.etc.value;
		fm.from_st.value 	= sh_fm.from_st.value;				
		fm.to_st.value 	= sh_fm.to_st.value;
		fm.from_place.value 	= sh_fm.from_place.value;				
		fm.to_place.value 	= sh_fm.to_place.value;
		fm.from_comp.value 	= sh_fm.from_comp.value;				
		fm.to_comp.value 	= sh_fm.to_comp.value;
		fm.from_title.value 	= sh_fm.from_title.value;				
		fm.from_man.value 	= sh_fm.from_man.value;
		fm.to_title.value 	= sh_fm.to_title.value;				
		fm.to_man.value 	= sh_fm.to_man.value;
		fm.from_tel.value 	= sh_fm.from_tel.value;				
		fm.from_m_tel.value 	= sh_fm.from_m_tel.value;
		fm.to_tel.value 	= sh_fm.to_tel.value;				
		fm.to_m_tel.value 	= sh_fm.to_m_tel.value;
		fm.from_req_dt.value 	= sh_fm.from_req_dt.value;				
		fm.from_req_h.value 	= sh_fm.from_req_h.value;
		fm.from_req_s.value 	= sh_fm.from_req_s.value;				
		fm.to_req_dt.value 	= sh_fm.to_req_dt.value;
		fm.to_req_h.value 	= sh_fm.to_req_h.value;				
		fm.to_req_s.value 	= sh_fm.to_req_s.value;
			
	
		if(fm.off_id.value == '')		{ alert('탁송업체를 선택하십시오.'); return; }		
		if(fm.off_nm.value == '')		{ alert('탁송업체를 선택하십시오.'); return; }
		if(fm.cons_cau.value == '')		{ alert('탁송사유를 입력하십시오.'); return; }		
		if(fm.from_st.value == '')		{ alert('출발 - 구분을 입력하십시오.'); return; }		
		if(fm.to_st.value == '')		{ alert('도착 - 구분을 입력하십시오.'); return; }		
			
		if(fm.size.value == '0')		{ alert(' 차량을 조회 하십시오.'); return; }
/*
	   if(confirm('등록하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='cons_reg_step1_off_a.jsp';
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}		
*/					
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "cons_reg_step1_off_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>

</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='off_id' value=''>
<input type='hidden' name='off_nm' value=''>
<input type='hidden' name='req_id' value=''>
<input type='hidden' name='cmp_app' value=''>
<input type='hidden' name='cons_st' value='1'> <!-- 편도 -->
<input type='hidden' name='cons_su' value='1'> <!-- 1대 -->
<input type='hidden' name='cons_cau' value=''>
<input type='hidden' name='cons_cau_etc' value=''>
<input type='hidden' name='cost_st' value=''>
<input type='hidden' name='pay_st' value=''>
<input type='hidden' name='etc' value=''>
<input type='hidden' name='from_st' value=''>
<input type='hidden' name='to_st' value=''>
<input type='hidden' name='from_place' value=''>
<input type='hidden' name='to_place' value=''>
<input type='hidden' name='from_comp' value=''>
<input type='hidden' name='to_comp' value=''>
<input type='hidden' name='from_title' value=''>
<input type='hidden' name='from_man' value=''>
<input type='hidden' name='to_title' value=''>
<input type='hidden' name='to_man' value=''>
<input type='hidden' name='from_tel' value=''>
<input type='hidden' name='from_m_tel' value=''>
<input type='hidden' name='to_tel' value=''>
<input type='hidden' name='to_m_tel' value=''>
<input type='hidden' name='from_req_dt' value=''>
<input type='hidden' name='from_req_h' value=''>
<input type='hidden' name='from_req_s' value=''>
<input type='hidden' name='to_req_dt' value=''>
<input type='hidden' name='to_req_h' value=''>
<input type='hidden' name='to_req_s' value=''>
<input type='hidden' name='client_id' value='000228'> <!-- 아마존카  --> 

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
                    <td width='10%' class='title'>차량번호</td>
                    <td width='16%' class='title'>차명</td>
                    <td width='13%' class='title'>위치</td>                                        
                    <td width='8%' class='title'>주행거리</td>
                    <td width='12%' class='title'>연료</td>
                    <td width='12%' class='title'>색상</td>
                    <td width='14%' class='title'>최초등록일</td>
                    <td width='11%' class='title'>소비자가격</td>
                               
                </tr>
<% 	
	//선택리스트
	
	
	String vid[] = request.getParameterValues("pr");
	String vid_num="";
	String ch_c_id="";
	String ch_off_id="";
   String ch_car_nm="";
   String ch_car_amt ="";
   
	int car_amt = 0;
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_c_id = token1.nextToken().trim();	 
				ch_off_id = token1.nextToken().trim();	 
				ch_car_nm = token1.nextToken().trim();	 
				ch_car_amt = token1.nextToken().trim();	 	
								
		}		
			//차량정보
	  olyBean = olpD.getPre_detail(ch_c_id);
	  car_no = olyBean.getCar_no();	
	   r_m_id = olyBean.getRent_mng_id();	
	   r_l_cd = olyBean.getRent_l_cd();	
	  
	   int cSum = olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getOpt_cs_amt() + olyBean.getOpt_cv_amt()+	olyBean.getClr_cs_amt() + olyBean.getClr_cv_amt();
	  	
			
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>
                		<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>            
                		<input type='hidden' name='car_nm' value='<%=ch_car_nm%>'>            
                		<input type='hidden' name='car_no' value='<%=car_no%>'>            
                		<input type='hidden' name='rent_mng_id' value='<%=r_m_id%>'>            
                		<input type='hidden' name='rent_l_cd' value='<%=r_l_cd%>'>           
                    <td><%=car_no%></td>
                    <td><%=ch_car_nm%></td>
                    <td><%=olyBean.getPark()%></td>
                    <td align='right'><%=AddUtil.parseDecimal(olyBean.getToday_dist())%></td>
                    <td><%=c_db.getNameByIdCode("0039", "", olyBean.getFuel_kd())%></td>
                    <td><span title='<%=olyBean.getColo()%>'><%=AddUtil.subData(olyBean.getColo(),6)%></span></td>
                    <td><%=AddUtil.ChangeDate2(olyBean.getInit_reg_dt())%></td>
                    <td align='right'><%=AddUtil.parseDecimal(cSum)%>&nbsp;&nbsp;</td>
                                             
               
                </tr>

<%		count++;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
		 
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
