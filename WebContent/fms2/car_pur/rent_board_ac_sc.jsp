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
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
									"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   				"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--	

	//��Ͽ�������Ʈ
	function select_rents(){
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
		 	alert("����� �����ϼ���.");
			return;
		}	
				
		fm.target = "_blank";
		fm.action = "rent_board_ac_excel.jsp";
		fm.submit();	
	}					
	
	
	//��Ͽ�������Ʈ
	function select_rents2(){
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
		 	alert("����� �����ϼ���.");
			return;
		}	
				
		fm.target = "_blank";
		fm.action = "rent_board_ac_excel_incheon.jsp";
		fm.submit();	
	}		
	
	//����� ��������Ʈ-������ ��û
	function select_rents_ins38(){
		var fm = inner.document.form1;	
		fm.target = "_blank";
		fm.action = "rent_board_ac_excel_ins38.jsp";
		fm.submit();	
	}
	
	//��༭ ���� ����
	function view_cont(m_id, l_cd, use_yn){
		var fm = document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;		
		fm.target ='d_content';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.submit();
	}
	
	function select_rents_ins_excel_com(){
		var fm = inner.document.form1;	
//		fm.ins_com_id.value = document.form1.ins_com_id.value;
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
		 	alert("����� �����ϼ���.");
			return;
		}	
				
		fm.target = "_blank";
		fm.action = "rent_board_ac_excel_ins_com.jsp";
		fm.submit();
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/rent_board_ac_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='send_id' value=''>    
  <input type='hidden' name='m_title' value=''>    
  <input type='hidden' name='m_content' value=''>    
  <input type='hidden' name='rece_id' value=''>    
  <input type='hidden' name='user_work' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td>
	  	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>

      &nbsp;&nbsp;<a href="javascript:select_rents();">[�μ�]</a>
      
		  &nbsp;&nbsp;<a href="javascript:select_rents2();">[����]</a> (�������� �μ�̸�����-����������(����|���40%|�¿쿩������)�ؾ� A4�� ���� ����Ҽ� �ֽ��ϴ�.

		  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
		  &nbsp;&nbsp;
		  <a href="javascript:select_rents_ins38();">[�������ս�û��]</a>
		  &nbsp;&nbsp;
		  <!--
		  <select name="ins_com_id">
        <option value="0038">����ī��������</option>
        <option value="0008">DB���غ���</option>
      </select>
      -->
		<input type="button" class="button" value='���� �ű԰��� ��û ���' onclick='javascript:select_rents_ins_excel_com();'>
		  <%}%>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="rent_board_ac_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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
