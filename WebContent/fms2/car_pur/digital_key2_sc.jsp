<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
	"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
	"&gubun4="+gubun4+"&gubun5="+gubun5+
	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���ó��
	function select_Dkey(){
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
		 	alert("ó���� ������ �����ϼ���.");
			return;
		}	
		
		fm.com_reg_dt.value = document.form1.com_reg_dt.value;
		
		fm.target = "i_no";
//		fm.target = "d_content";
//		fm.action = "digital_key2_act_a.jsp";
//		fm.submit();	
	}
	
	//��û
	function reg_Dkey(m_id, l_cd){
		window.open("digital_key2_reg.jsp?m_id="+m_id+"&l_cd="+l_cd, "REG_DKEY", "left=100, top=10, width=1200, height=650, resizable=yes, scrollbars=yes, status=yes");				
	}		

	//��ĵ���� ����
	function view_scan(m_id, l_cd)
	{
		window.open("/fms2/lc_rent/view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes, status=yes");								
	}	

//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/digital_key2_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	      <td>
	      <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>  
	        <!-- 
	        <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������Ű�δ��",user_id) || nm_db.getWorkAuthUser("�����������������",user_id)){%>
	        &nbsp;&nbsp;&nbsp;
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>&nbsp;
	        <input type='text' name="com_reg_dt" value='<%=AddUtil.getDate()%>' size='11' class='text'>&nbsp;&nbsp;&nbsp;
	        <a href="javascript:select_Dkey();">[������ ������Ű ���]</a>
	        <%}%>
	        &nbsp;&nbsp;&nbsp;
	         -->
	        <font color=red>�� ������Ű2�� �ִ� ����(Ʈ��), �ɼ��� �ִ� �����Դϴ�. </font>
	      	</td>
	  </tr>
	  <tr>
	      <td>
    		    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		        <tr>
        			      <td>
        			          <iframe src="digital_key2_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        			      </td>
    		        </tr>
    		    </table>
	      </td>
    </tr>
    	  <tr>
	      <td class=h></td>
	  </tr>
    <tr>
	      <td>�� <a href="https://www.hyundai.com/kr/ko/customer-service/bluelink/bluelink-service/digital-key-2/digital-key-registration" target=_blank title='���� ������Ű2'>���� ������Ű2 ��ũ</a>
	      &nbsp;&nbsp;
	          <a href="https://connect.kia.com/kr/01_service/digital_key.html" target=_blank title='��� ������Ű2'>��� ������Ű2 ��ũ</a>
	      </td>
	  </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
