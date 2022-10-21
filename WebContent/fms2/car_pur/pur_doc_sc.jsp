<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_ts.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//거래처 보기 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=800, resizable=yes, scrollbars=yes, status=yes");
	}

	//영업사원보기
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/acar/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/commi_pay_s_frame.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=800, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//계약금문서보기
	function view_con_doc(rent_mng_id, rent_l_cd){
		var fm = document.form1;
		 		   
		var SUBWIN= "/fms2/car_pur/view_con_doc.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
		window.open(SUBWIN, "COMMI_PAY", "left=50, top=50, width=720, height=650, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function doc_action(scan_doc_cnt, chk_cnt, mode, rent_mng_id, rent_l_cd, doc_no, doc_bit, car_off_nm){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 		= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
			
		if(car_off_nm == ''){
			alert('출고영업소가 등록되지 않았습니다. 계약관리에서 먼저 등록하세요.');
			return;
		}
		
		if(doc_no == ''){
		
			if(scan_doc_cnt > 0){
				fm.action = 'pur_doc_i.jsp';
			}else{
				//alert('지급요청 조건이 충족하지 않은것이 있습니다. 확인하십시오.');
				alert('계약서 스캔이 없습니다. 확인하십시오.');
				return;
			}
		}else{
			fm.action = 'pur_doc_u.jsp';
			
			if(doc_bit > 4 || '<%=user_id%>'=='000004'){
				fm.action = 'pur_doc_c.jsp';
			}
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	//기안취소
	function doc_cancel(doc_no, rent_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.doc_no.value 		= doc_no;		
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;	
		if(confirm('기안 및 등록을 취소하시겠습니까?')){	
			fm.action = 'pur_doc_d_a.jsp';
			fm.target = 'd_content';
			fm.submit();
		}
	}
	
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}		
	
	
	//출고계약 선택
	function select_purs_amt(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		var purs_amt2 = 0;
		var purs_dt  = "";
		var card_yn  = "";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;					
					idnum=ck.value;
					var ch_split = idnum.split("/");					
					purs_dt = ch_split[1];
					if(purs_dt == document.form1.est_dt.value || document.form1.est_dt.value == ''){
						purs_amt = purs_amt + toInt(ch_split[0]);
					}	
					card_yn = ch_split[5];
					if(card_yn == 'Y'){
						purs_amt2 = purs_amt2 + toInt(ch_split[0]);
					}
				}
			}
		}	
		if(cnt == 0){
		 	document.form1.est_amt.value = 0;
		 	document.form1.est_amt2.value = 0;
		}			
		document.form1.est_amt.value = parseDecimal(purs_amt);
		document.form1.est_amt2.value = parseDecimal(purs_amt2);
	}	
	
	//출고계약 선택
	function select_purs_dt(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		var purs_dt  = "";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			idnum=ck.value;			
			var ch_split = idnum.split("/");					
			purs_dt = ch_split[1];			
			if(purs_dt == document.form1.est_dt.value || document.form1.est_dt.value == ''){
				ck.checked = true;
			}else{
				ck.checked = false;
			}			
		}	
		select_purs_amt();
	}			
	
	//스캔관리 보기
	function reg_delay_cont(m_id, l_cd)
	{
		window.open("reg_delay_cont.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_DELAY", "left=100, top=10, width=600, height=300, resizable=yes, scrollbars=yes, status=yes");		
	}
		
	//배달탁송 선의뢰
	function reg_cons(m_id, l_cd){
		window.open("reg_cons.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_CONS", "left=100, top=10, width=720, height=750, resizable=yes, scrollbars=yes, status=yes");				
	}	
	
	//임시운행보험료
	function reg_trfamt5(m_id, l_cd){
		window.open("reg_trfamt5.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_CONS", "left=100, top=10, width=1000, height=300, resizable=yes, scrollbars=yes, status=yes");				
	}		
	
	//엑셀파일
	function list_excel(){
		window.open("pur_doc_sc_excel.jsp<%=valus%>", "LIST_EXCEL", "left=100, top=10, width=1500, height=750, resizable=yes, scrollbars=yes, status=yes");				
	}	
	
	//대출공문작성 
	function select_bank_reg(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var purs_amt = 0;
		var purs_dt  = "";
		var gov_id  = "";
		var card_cnt  = 0;
		var car_st  = "";
		var car_st_cnt = 0;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;					
					idnum=ck.value;
					var ch_split = idnum.split("/");					
					purs_dt = ch_split[1];
					if(purs_dt == document.form1.est_dt.value || document.form1.est_dt.value == ''){
						purs_amt = purs_amt + toInt(ch_split[0]);
					}	
					gov_id = ch_split[4];
					if(gov_id != ''){
						card_cnt += 1; 
					}
					car_st = ch_split[6];
					if(car_st == '3'){
						car_st_cnt += 1; 
					}
				}
			}
		}
		
		if(cnt == 0){
			alert("대출신청할 건을 체크 해주세요");
			return;
		}	
		if(card_cnt > 0){
			alert(card_cnt+"건의 기대출된 건이 선택되었습니다. 체크해제 하세요");
			return;
		}
		
		if(car_st_cnt > 0){
			alert(car_st_cnt+"건의 리스차량이 선택되었습니다. 체크해제 하세요");
			return;
		}
	  
		var newWin = window.open("", "pop", "left=300, top=200, width=820, height=750, resizable=yes, scrollbars=yes, status=yes");
		
		fm.target = "pop";
		fm.action = "/acar/bank_mng/bank_doc_reg_sh.jsp?card=Y&gov_id="+gov_id;
		fm.submit();		
			
	}		
	
	
//-->
</script>

<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	    <%if(!gubun1.equals("0")) { %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name='est_dt' onChange='javascript:select_purs_dt();'>
		    <option value=''>전체</option>		    
          	    <%for (int i = 0 ; i < 4 ; i++){
          	    		String est_dt = c_db.addDay(AddUtil.getDate(4), i);          	    		
          	    		String est_dt_nm = "";
          	    		if(i==0) est_dt_nm = "오늘";
          	    		if(i==1) est_dt_nm = "내일";
          	    		if(i==2) est_dt_nm = "모레";
          	    		if(i==3) est_dt_nm = "글피";
          	    		
          	    %>
		    <option value='<%=est_dt%>'><%=est_dt_nm%></option>
          	    <%}%>
	        </select>		        
	        &nbsp;&nbsp;&nbsp;
		* 지출예상금액 : <input type='text' name='est_amt' maxlength='10' value='' class='whitenum' size='10'>원
		&nbsp;&nbsp;
		(카드할부예상금액 : <input type='text' name='est_amt2' maxlength='10' value='' class='whitenum' size='10'>원)
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<% if ( nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("대출관리자",user_id) || nm_db.getWorkAuthUser("차량대금기안자",user_id) || nm_db.getWorkAuthUser("본사총무팀장",user_id) ) {%>
		<a href="javascript:select_bank_reg()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[대출공문작성]</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	    <% } %>	
		<a href="javascript:list_excel()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_excel.gif border=0></a>
		<%} %>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="pur_doc_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
    <tr>
	    <td>※ 차량대금문서처리 미결리스트에 안나오는 계약은 계약관리에서 영업사원-출고담당에 입력 여부를 확인하세요.</td>
	</tr>	
</table>
</form>
</body>
</html>
