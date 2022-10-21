<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "04");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
					
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function view_cons(cons_no){
		var fm = document.form1;
		fm.cons_no.value 		= cons_no;
		fm.action = 'cons_reg_step3.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
	
	function list_print(){
//		var width 	= screen.width;
		var width 	= 1024;		
		var height 	= screen.height;		
		window.open("cons_req_list_print.jsp<%=valus%>", "Print", "left=0, top=0, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");				
	}
	
	//청구서작성
	function select_cons(){
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
		 	alert("청구할 탁송을 선택하세요.");
			return;
		}
		if(!confirm('탁송을 청구 하시겠습니까?')){	return; }		
		fm.req_dt.value = document.form1.req_dt.value;
//		fm.target = "i_no";
		fm.target = "d_content";
		fm.action = "cons_conf_a.jsp";
		fm.submit();	
	}		
	
	//용품비용 청구확인 문자발송
	function conf_sms_tint(){
		var fm = document.form1;			
		if(!confirm('청구확인 메모를 발송하시겠습니까?')){	return; }		
		fm.target = "i_no";
		//fm.target = "_blank";
		fm.action = "cons_r_sms_a.jsp";
		fm.submit();	
	}	

	//일괄결재작성
	function conf_tot_sign(){
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
		 	alert("청구할 탁송을 선택하세요.");
			return;
		}	
		
		if(!confirm('관리자 일괄확인을 하시겠습니까?')){	return; }
		fm.target = "d_content";
		fm.action = "cons_conf_sign.jsp";
		fm.submit();	
	}	
	
	function cons_doc_tot(){
//		var width 	= screen.width;
		var width 	= 1024;		
		var height 	= screen.height;		
		window.open("cons_req_drv_tot.jsp<%=valus%>", "Print", "left=0, top=0, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");				
	}
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_req_frame2.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name="doc_bit" value="">
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	  <td>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) && (nm_db.getWorkAuthUser("지점장",user_id)||nm_db.getWorkAuthUser("탁송관리자",user_id)||nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>청구일자</span>&nbsp;<input type='text' name="req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text'>&nbsp;&nbsp;&nbsp;
	  <a href="javascript:select_cons();"><img src="/acar/images/center/button_tsr_gian.gif" align=absmiddle border="0"></a>&nbsp;
	  <%}%>
	  <!--
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("전산팀",user_id)) || (nm_db.getWorkAuthUser("탁송관리자",user_id))){%>   
	  <a href="javascript:conf_sms_tint();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_sms_conf.gif" align="absmiddle" border="0"></a>&nbsp;
	  
	  <%}%>
	  <%if((nm_db.getWorkAuthUser("전산팀",user_id)) || (user_id.equals("000144")||user_id.equals("000128")||user_id.equals("000003"))){%>   
	  <a href="javascript:conf_tot_sign();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_iggj.gif" align="absmiddle" border="0"></a>&nbsp;
	  
	  <%}%>
	  -->
	  <a href="javascript:list_print()"><img src="/acar/images/center/button_print.gif" align=absmiddle border="0"></a><font color=#CCCCCC>&nbsp;(※인쇄TIP : A4, 가로방향)</font>&nbsp;&nbsp;
	  <a href="javascript:cons_doc_tot();">기사별현황</a>
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="cons_req_sc_in2.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
