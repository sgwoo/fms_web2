<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-60;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function move_page_mng(st, gubun, idx){
		var fm = document.form1;

		fm.gubun1.value = '';
		fm.gubun2.value = '';
		fm.gubun3.value = '';
		fm.gubun4.value = '';
		fm.gubun5.value = '';
		fm.gubun6.value = '';
		
		if(st == 1){//보험가입현황
			if(gubun == 'N'){			
											fm.gubun2.value = '5';
											fm.gubun3.value = '5';
				if     (idx   ==  1 ){		fm.gubun4.value = '1';									}
				else if(idx   ==  2 ){		fm.gubun4.value = '2';									}
				else if(idx   ==  3 ){		fm.gubun4.value = '3';									}
			}else{
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
				if     (idx   ==  1 ){		fm.gubun3.value = '1';	fm.gubun4.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun3.value = '1';	fm.gubun4.value = '2';			}
				else if(idx   ==  3 ){		fm.gubun3.value = '2';									}
			}
		}else if(st == 3){//보험사항변경현황
			if(gubun == 'D'){				fm.gubun2.value = '1';									}
			else if(gubun == 'M'){			fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';
			if     (idx   ==  1 ){			fm.gubun4.value = '1';									}
			else if(idx   ==  2 ){			fm.gubun4.value = '2';									}
			else if(idx   ==  3 ){			fm.gubun4.value = '3';									}
			else if(idx   ==  4 ){			fm.gubun4.value = '4';									}
			else if(idx   ==  5 ){			fm.gubun4.value = '5';									}
		}else if(st == 4){//보험해지현황
			if(gubun == 'N'){	
											fm.gubun2.value = '5';					
											fm.gubun3.value = '6';
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
			}else{			
				if(gubun == 'D'){			fm.gubun2.value = '1';									}
				else if(gubun == 'M'){		fm.gubun2.value = '2';									}
											fm.gubun3.value = '3';									
				if     (idx   ==  1 ){		fm.gubun1.value = '1';	fm.gubun5.value = '1';			}
				else if(idx   ==  2 ){		fm.gubun1.value = '2';	fm.gubun5.value = '1';			}
				else if(idx   ==  3 ){		fm.gubun1.value = '2';	fm.gubun5.value = '3';			}
				else if(idx   ==  4 ){		fm.gubun1.value = '2';	fm.gubun5.value = '2';			}				
			}

		}		
		fm.target.value = "d_content";			
		fm.action = "ins_s_frame.jsp";		
		fm.submit();
	}
	
	function insDisp(m_id, l_cd, c_id, ins_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.target.value = "d_content";
		fm.action = "ins_u_frame.jsp";
		fm.submit();
	}
	//갱신
	function insReg(m_id, l_cd, c_id, ins_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.target.value = "d_content";
		fm.action = "../ins_reg/ins_reg_frame.jsp";		
		fm.submit();
	}
	//해지
	function insCls(m_id, l_cd, c_id, ins_st){
//		window.open("ins_u_in4.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&ins_st="+ins_st+"&mode=cls", "INS_CLS", "left=20, top=20, width=875, height=550, scrollbars=yes");
		window.open("about:blank", "INS_CLS", "left=20, top=20, width=875, height=550, scrollbars=yes");
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.mode.value = "cls";
		fm.action = "../ins_mng/ins_u_in4.jsp";		
		fm.target = "INS_CLS";
		fm.submit();		
	}		
	


-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>


<form name='form1' action='ins_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td><iframe src="ins_b_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&dt=<%=dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
  </table>
</form>
</body>
</html>
