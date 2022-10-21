<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*"%>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "10");	
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	int alt_amt = 0;		
	
	CarRegDatabase cdb = CarRegDatabase.getInstance();
	RentListBean rl_r [] = cdb.getRegListAll2(br_id, st_dt,end_dt,s_kd,t_wd,sort,asc);
	
	int reg_amt = 0;
	int acq_amt = 0;
	int no_m_amt = 0;
	
	int total_a_amt  = 0;
	int total_b_amt = 0;
	int total_c_amt = 0;
	int total_d_amt = 0;
	int total_e_amt = 0;
	
   String c_reg_dt = "";

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//한건조회
	function CarRegList(brch_id, rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt, car_name)
	{
		var theForm = document.CarRegDispForm;
		theForm.rent_mng_id.value 	= rent_mng_id;
		theForm.rent_l_cd.value 	= rent_l_cd;
		theForm.car_mng_id.value 	= car_mng_id;
		theForm.cmd.value 			= reg_gubun;
		theForm.action = "/acar/car_register/register_frame.jsp";
		theForm.target = "d_content"
		theForm.submit();
	}


	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function save(car_mng_id, car_no, firm_nm, init_reg_dt, alt_amt){
						
		if(!confirm("자동전표를 생성하시겠습니까?"))	return;
		
		var fm = document.form1;
		fm.car_mng_id.value = car_mng_id;
		fm.car_no.value = car_no;
		fm.firm_nm.value = firm_nm;
		fm.init_reg_dt.value = init_reg_dt;
		fm.alt_amt.value = alt_amt;
		
		fm.action = 'exp_reg_autodoc_a.jsp';
		fm.target="i_no";		
		fm.submit();
	
	}
	
	function All_Autodocu(){
		fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("일괄 처리할 건을 선택하세요.");
			return;
		}					
		if(!confirm("자동전표를 생성하시겠습니까?"))	return;
		fm.action = 'exp_reg_autodoc_all_a.jsp';
		fm.target = '_blank';
		fm.submit();			
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}		
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form  name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="1490">
    <tr>
        <td><a href="javascript:All_Autodocu();">[일괄전표발행]</a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">            	
            	<tr>
            		<td class=line>
            			<table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                                <td width=50 class=title>연번</td>
                                <td width=100 class=title>계약번호</td>
                                <td width=170 class=title>상호</td>                      
                                <td width=100 class=title>차량번호</td>
                                <td width=120 class=title>차명</td>
                                <td width=110 class=title>계출번호</td>                                
	                            <td width=90 class=title>등록일</td>
		                		<td width=100 class=title>등록세</td>
		                		<td width=100 class=title>취득세</td>
		                		<td width=100 class=title>제작비</td>
		                		<td width=100 class=title>기타</td>
		                		<td width=100 class=title>공채할인시</td>
		                		<td width=70 class=title>자동전표</td>
		                		<td width=90 class=title>계약일</td>
                                <td width=40 class=title>지점</td>
                            </tr>
                          <%if(rl_r.length != 0){ %>
                          <% 	for(int i=0; i<rl_r.length; i++){
                          			alt_amt = 0;
                    				rl_bean = rl_r[i];
                    				
                    				cr_bean = cdb.getCarRegBean(rl_bean.getCar_mng_id());
                    				
                    				reg_amt = cr_bean.getReg_amt(); //등록세
                    				acq_amt = cr_bean.getAcq_amt(); //취득세
                    				no_m_amt= cr_bean.getNo_m_amt(); //번호판제작비
                    				
                    				if ( cr_bean.getReg_amt_card().equals("Y")) {
                    					reg_amt  = 0;
                    				}                     			
                    			
                    				if ( cr_bean.getAcq_amt_card().equals("Y")) {
                    					acq_amt  = 0;
                    				}              
                    				
                    				if ( cr_bean.getNo_amt_card().equals("Y")) {
                    					no_m_amt  = 0;
                    				} 
                    			
                    				alt_amt = reg_amt + acq_amt + cr_bean.getLoan_s_amt() +  cr_bean.getStamp_amt() + no_m_amt + cr_bean.getEtc();
                    				
             					total_a_amt = total_a_amt + cr_bean.getReg_amt();
             					total_b_amt = total_b_amt + cr_bean.getAcq_amt();
             					total_c_amt = total_c_amt + cr_bean.getNo_m_amt();
             					total_d_amt = total_d_amt + cr_bean.getEtc();
             					total_e_amt = total_e_amt + cr_bean.getLoan_s_amt();
             				             					             			             				            				             					
             					//등록일 
             					c_reg_dt = rl_bean.getInit_reg_dt() ;
             					if (!rl_bean.getSh_base_dt().equals("") ) 	c_reg_dt = cr_bean.getReg_pay_dt();             					
             					
                    	  %>
                            <tr> 
                                <td align="center">
                                  <%if( rl_bean.getCar_a_yn().equals("0") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                                  <input type="checkbox" name="ch_l_cd" value="<%=rl_bean.getCar_mng_id()%>/<%=rl_bean.getCar_no()%>^<%=cr_bean.getCar_ext()%>^<%=cr_bean.getCar_use()%>^<%=cr_bean.getFuel_kd()%>/<%= rl_bean.getFirm_nm() %>/<%=c_reg_dt %>/<%=reg_amt%>^<%=acq_amt%>^<%=cr_bean.getLoan_s_amt()%>^<%=cr_bean.getStamp_amt()%>^<%=no_m_amt%>^<%=cr_bean.getEtc()%>^<%=alt_amt%>"></td>
                                  <%}else{%>
                	              -
                	              <%}%>
                                <td align="center"><%=i+1%></td>
                                <td align="center"><%= rl_bean.getRent_l_cd() %></td>
                                <td align="left">&nbsp;<span title=" <%= rl_bean.getFirm_nm() %>"><%= Util.subData(rl_bean.getFirm_nm(),10) %></span></td>                       
                                <td align="center"><%= rl_bean.getCar_no() %></td>
                                <td align="left">&nbsp;<span title="<%=rl_bean.getCar_nm()%> <%=rl_bean.getCar_name()%>"><%= Util.subData(rl_bean.getCar_nm()+" "+rl_bean.getCar_name(),8) %></span></td>
                                <td align="center"><%= rl_bean.getRpt_no() %></td>
                		        <td align="center"><%=c_reg_dt %></td>
                                <td align="right"><%=Util.parseDecimal(rl_bean.getReg_amt())%></td>	
                                <td align="right"><%=Util.parseDecimal(rl_bean.getAcq_amt())%>
                                <% if ( rl_bean.getAcq_amt() != cr_bean.getAcq_amt() ) {%><br>납부일자 확인 <% } %>
                                </td>	
                                <td align="right"><%=Util.parseDecimal(rl_bean.getNo_m_amt())%></td>	
                                <td align="right"><%=Util.parseDecimal(rl_bean.getEtc())%></td>	
                                 <td align="right"><%=Util.parseDecimal(rl_bean.getLoan_s_amt())%></td>	 
                                
                                <td align='center'> 
                	              <%if( rl_bean.getCar_a_yn().equals("0") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                	              
                	              <a href="javascript:save('<%=rl_bean.getCar_mng_id()%>', '<%=rl_bean.getCar_no()%>^<%=cr_bean.getCar_ext()%>^<%=cr_bean.getCar_use()%>^<%=cr_bean.getFuel_kd()%>', '<%= rl_bean.getFirm_nm() %>', '<%=c_reg_dt %>', '<%=reg_amt%>^<%=acq_amt%>^<%=cr_bean.getLoan_s_amt()%>^<%=cr_bean.getStamp_amt()%>^<%=no_m_amt%>^<%=cr_bean.getEtc()%>^<%=alt_amt%>')"><img src=../images/center/button_in_bh.gif align=absmiddle border=0></a> 
                	              <%}else{%>
                	              -
                	              <%}%>
                	   
                	            </td>
                                <!--<td width=100 align="center"><%= rl_bean.getCar_a_yn() %></td>-->			
                		        <td align="center"><%= rl_bean.getRent_dt() %></td>	
                                <td align="center"><%= rl_bean.getBr_id() %></td>
                            </tr>
                          <%	}%>
                              <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>               
                    <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_a_amt)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_b_amt)%></td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_c_amt)%></td>		
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_d_amt)%></td>		
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_e_amt)%></td>		
                     <td class="title">&nbsp;</td>						
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
             				
                </tr>
                          <%}%>			  
            			  <%if(rl_r.length == 0){ %>			  
                            <tr> 
                                <td colspan="14" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
            			  <%}%>			  
                       </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="car_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="init_reg_dt" value="">
<input type="hidden" name="alt_amt" value="">
<input type="hidden" name="cmd" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</body>
</html>


