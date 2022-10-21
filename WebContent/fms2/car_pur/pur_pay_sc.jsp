<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>
<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--

	function conamt_card_req(){
		var SUBWIN= "/fms2/car_pur/conamt_card_req_list.jsp";
		window.open(SUBWIN, "Pur_Doc_Card", "left=50, top=50, width=1000, height=760, resizable=yes, scrollbars=yes, status=yes");	
	}
	
	//팩스보내기
	function Pur_DocPrint(rent_mng_id, rent_l_cd, num)
	{
		var SUBWIN= "/fms2/car_pur/pur_doc_fax.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&num="+num;
		window.open(SUBWIN, "Pur_DocPrint", "left=50, top=50, width=1000, height=760, resizable=yes, scrollbars=yes, status=yes");
	}

	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=720, height=600, resizable=yes, scrollbars=yes, status=yes");
	}
	
	function view_pur_doc(rent_mng_id, rent_l_cd, car_gu){
		var fm = document.form1;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
			
		window.open('about:blank', "View_PUR_DOC", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.mode.value = 'view';
		
		fm.action = 'pur_doc_c.jsp';
		
		if(car_gu == '중고차'){
				fm.action = 'pur_doc_ac_u.jsp';
		}
		fm.target = 'View_PUR_DOC';
		fm.submit();
			
//		var SUBWIN= "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;//+"&mode=view"
//		window.open(SUBWIN, "View_PUR_DOC", "left=50, top=50, width=1000, height=700, resizable=yes, scrollbars=yes, status=yes");	
	}
	
	function doc_action(mode, rent_mng_id, rent_l_cd, doc_no){
		var fm = document.form1;
		fm.mode.value 			= mode;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.doc_no.value 		= doc_no;
			
		window.open('about:blank', "PURPAYDOC", "left=0, top=0, width=1500, height=900, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PURPAYDOC";
		fm.action = "pur_pay_doc.jsp";
		fm.submit();
	}
	
	function pay_action(trf_st, rent_mng_id, rent_l_cd, pur_pay_dt){
		var fm = document.form1;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.trf_st.value 		= trf_st;		
		fm.pur_pay_dt.value		= pur_pay_dt;
			
		window.open('about:blank', "PURPAY", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
		if(pur_pay_dt == ''){
			fm.action = 'pur_pay_i.jsp';
		}else{
			fm.action = 'pur_pay_c.jsp';
		}
		fm.target = 'PURPAY';
		fm.submit();
	}	

	//지출서작성
	function select_purs(){
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
		 	alert("지출할 계약을 선택하세요.");
			return;
		}	
		
		window.open('about:blank', "PURPAYDOC", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PURPAYDOC";
		fm.action = "pur_pay_doc.jsp";
		fm.submit();	
	}				
	
	
	//취득세명의변경 일괄등록
	function select_acq_purs(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch2_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("지출할 계약을 선택하세요.");
			return;
		}	
		
		window.open('about:blank', "PURPAYACQ", "left=0, top=0, width=650, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "PURPAYACQ";
		fm.action = "pur_pay_acq_cng.jsp";
		fm.submit();	
	}				
		
	//결재취소
	function cancel_purs(){
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
		 	alert("취소할 계약을 선택하세요.");
			return;
		}	
		
		window.open('about:blank', "PURPAYDOC2", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
//		fm.target = "i_no";
		fm.target = "PURPAYDOC2";		
		fm.action = "pur_pay_doc_cancel.jsp";
		fm.submit();	
	}				
		
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}

	//일괄팩스 보내기
	function select_doc_fax(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch3_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("팩스보낼 계약을 선택하세요.");
			return;
		}	
		
		window.open('about:blank', "PURPAYDOCFAX", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
//		fm.target = "i_no";
		fm.target = "PURPAYDOCFAX";		
		fm.action = "pur_doc_fax_select.jsp";
		fm.submit();	
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_pay_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='trf_st' value=''>  
  <input type='hidden' name='pur_pay_dt' value=''>  
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) && (nm_db.getWorkAuthUser("부산출납",user_id)||nm_db.getWorkAuthUser("대전출납",user_id)||nm_db.getWorkAuthUser("본사출납",user_id)||nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)||nm_db.getWorkAuthUser("출고관리자",user_id)||nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  <a href="javascript:select_purs();"><img src=/acar/images/center/button_gjga.gif align=absmiddle border=0></a>
	  &nbsp;&nbsp;<a href="javascript:select_acq_purs();">[취득세명의변경 일괄등록]</a>	  
	  <%}%>	  
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){%>
	  &nbsp;&nbsp;<a href="javascript:cancel_purs();"><img src=/acar/images/center/button_cancel_gj.gif align=absmiddle border=0></a>
	  <%}%>
	  &nbsp;&nbsp;<a href="javascript:select_doc_fax();">[일괄팩스보내기]</a>
	  &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:conamt_card_req();">[계약금카드결재 당일요청리스트]</a>
	  
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="pur_pay_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
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
