<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
				   	"&sh_height="+height+"";
						
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>

	//거래처 보기 
	function view_client(rent_mng_id, rent_l_cd, r_st)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=820, height=800, resizable=yes, scrollbars=yes");
	}

	
	function doc_action(mode, rent_mng_id, rent_l_cd, car_mng_id, ins_st, doc_no, ins_doc_no, doc_bit){
		var fm = document.form1;
		fm.mode.value 		= mode;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 	= rent_l_cd;
		fm.car_mng_id.value 	= car_mng_id;
		fm.ins_st.value 	= ins_st;
		fm.doc_no.value 	= doc_no;		
		fm.ins_doc_no.value 	= ins_doc_no;
		fm.flag.value = "ins_doc_end_sc_in";
		fm.action = 'ins_doc_u4.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}
	

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//복구
	function replace_ins(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("선택된 내용이 없습니다");
			return;
		}	
		
		//fm.size.value = document.form1.size.value;
		
		act_ment="복구";
				
		if(confirm(act_ment+' 하시겠습니까?')){
			 window.open("" ,"form1", 
		       "toolbar=no, width=600, height=150, directories=no, status=no,    scrollorbars=no, resizable=no"); 
			
			fm.action = "ins_doc_end_sc_re.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method="post";
			fm.submit();	
		}
	}	
			
</script>
</head>
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/insure/ins_doc_end_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='car_mng_id' value=''>
  <input type='hidden' name='ins_st' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='ins_doc_no' value=''>    
  <input type='hidden' name='mode' value=''>
  <input type='hidden' name='flag' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	<td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td>
			 	<input type="button" class="button btn-submit" value="복구" onclick="replace_ins()" style="margin-left:40px;"/>
		    </td>
		</tr>
		<tr>
		    <td>
		    </td>
		</tr>
		<tr>
		    <td>
		    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
		    </td>
		</tr>
		<tr>
			<td>
				<iframe src="ins_doc_end_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		</tr>
	    </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>
