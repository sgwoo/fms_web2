<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&start_dt="+start_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function  view_doc(doc_no, doc_st, doc_id, rent_mng_id, rent_l_cd, doc_bit){
		var fm = document.form1;
		fm.doc_st.value 		= doc_st;
		fm.doc_id.value 		= doc_id;
		fm.doc_no.value 		= doc_no;
		fm.doc_bit.value 		= doc_bit;		
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.cons_no.value 		= doc_id;
		fm.req_code.value 		= doc_id;		
		fm.mode.value			= 'doc_settle';
			
		if(doc_st == '1')			fm.action = '/fms2/commi/commi_doc_u.jsp';		
		
		if(doc_st == '2'){
			if(doc_bit == '1')	fm.action = '/fms2/consignment/cons_reg_step2.jsp';
			else 								fm.action = '/fms2/consignment/cons_reg_step3.jsp';
		}	
		
		if(doc_st == '3')			fm.action = '/fms2/consignment/cons_req_doc.jsp';
		
		if(doc_st == '4')			fm.action = '/fms2/car_pur/pur_doc_u.jsp';		
		
		if(doc_st == '5')			fm.action = '/fms2/car_pur/pur_pay_doc.jsp';	
		
		if(doc_st == '6'){
			if(doc_bit == '1')	fm.action = '/fms2/tint/tint_reg_step2.jsp';
			else 								fm.action = '/fms2/tint/tint_reg_step3.jsp';
		}	
				
		if(doc_st == '7')			fm.action = '/fms2/tint/tint_doc.jsp';
		
		if(doc_st == '8')			fm.action = '/fms2/over_time/over_time_frame.jsp';

		if(doc_st == '11')	{
			if(doc_bit == '1')				fm.action = '/fms2/cls_cont/lc_cls_u1.jsp';
			else 	if(doc_bit == '2')	fm.action = '/fms2/cls_cont/lc_cls_u2.jsp';
			else 											fm.action = '/fms2/cls_cont/lc_cls_d_frame.jsp';
		}		
		
		if(doc_st == '21')			fm.action = '/fms2/free_time/free_time_frame.jsp';
		if(doc_st == '22')			fm.action = '/fms2/free_time/free_time_frame.jsp';		
		
		if(doc_st == '31')			fm.action = '/fms2/pay_mng/pay_d_frame.jsp';	
		if(doc_st == '32')			fm.action = '/fms2/pay_mng/pay_a_frame.jsp';	
		
		if(doc_st == '31'){
			fm.s_kd.value = '2';
			fm.t_wd.value = '';
			if(doc_bit == '3')		fm.gubun2.value='2';
			else									fm.gubun2.value='1';
		}
					
		if(doc_st == '32'){
			fm.s_kd.value = '7';
			fm.t_wd.value = '';
			if(doc_bit == '3')		fm.gubun5.value='2';
			else									fm.gubun5.value='1';
		}
				
		fm.target = 'd_content';
		fm.submit();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//연차/특근신청 내용보기
	function  view_doc2(user_id1, doc_id, doc_st){
		var fm = document.form1;
		fm.doc_st.value 		= doc_st;
		fm.doc_no.value 		= doc_id;
		fm.user_id.value		= user_id1;

		if(doc_st == '8')			fm.action = '/fms2/over_time/over_time_c.jsp';
		if(doc_st == '9')			fm.action = '/fms2/watch/watch.jsp';
		if(doc_st == '21')		fm.action = '/fms2/free_time/free_time_c.jsp';
		if(doc_st == '22')		fm.action = '/fms2/free_time/free_time_cancel_c.jsp';						
				
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//결재자일괄변경
	function select_doc_cng(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("일괄변경할 문서를 선택하세요.");
			return;
		}
		
		
		
		fm.user_st.value = document.form1.user_st.value;
		
		
		
		window.open('about:blank', "DOCSEETLEUSERCNG", "left=0, top=0, width=500, height=200, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DOCSEETLEUSERCNG";
		fm.action = "doc_user_all_cng.jsp";
		fm.submit();	
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun5' 	value=''>      
  <input type='hidden' name='start_dt' 	value='<%=start_dt%>'>    
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/doc_settle/doc_settle_n_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='doc_st' value=''>  
  <input type='hidden' name='doc_id' value=''>      
  <input type='hidden' name='doc_bit' value=''>        
  <input type='hidden' name='cons_no' value=''>        
  <input type='hidden' name='req_code' value=''>          
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src="/acar/images/center/icon_arrow.gif" border="0" align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)){ %>
	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  	<select name="user_st">                    
                    <option value="user_id2">결재자2</option>
                    <option value="user_id3">결재자3</option>
                    <option value="user_id4">결재자4</option>
                    <option value="user_id5">결재자5</option>
                    <option value="user_id6">결재자6</option>
                    <option value="user_id7">결재자7</option>
                    <option value="user_id8">결재자8</option>
                    <option value="user_id9">결재자9</option>
                </select>
                &nbsp;
	  	<a href="javascript:select_doc_cng();">[일괄변경]</a>
	  	<%}%>
	  	</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="doc_settle_n_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
