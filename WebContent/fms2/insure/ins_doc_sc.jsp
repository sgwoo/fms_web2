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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
				   	"&sh_height="+height+"";
						
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script>
	//�ŷ�ó ���� 
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
		fm.action = 'ins_doc_u.jsp';	
		if(doc_bit == '1') 		fm.action = 'ins_doc_u2.jsp';
		//if(doc_bit == '2') 	fm.action = 'ins_doc_u3.jsp';
		if(doc_bit == '2') 		fm.action = 'ins_doc_u4.jsp';
		if(doc_bit == '3') 		fm.action = 'ins_doc_u4.jsp';
		if(doc_bit == '4') 		fm.action = 'ins_doc_u4.jsp';
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//�����û��
	function select_inss(){
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
		 	alert("��û���� �� ���躯���� �����ϼ���.");
			return;
		}	
		
		window.open('about:blank', "INSDOC_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "INSDOC_PRINT";
		fm.action = "ins_doc_print2.jsp";
		fm.submit();	
	}			
	
	function changeUserType(value){
		var fm = inner.document.form1;
		fm.user_type.value = value;
	}
	
	function changeUserName(value){
		var fm = inner.document.form1;
		fm.user_name.value = value;
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
  <input type='hidden' name='from_page' value='/fms2/insure/ins_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='car_mng_id' value=''>
  <input type='hidden' name='ins_st' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='ins_doc_no' value=''>    
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	<td>
	    <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>		
	    &nbsp;&nbsp;<a href="javascript:select_inss();">[��������׺����û��]</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		��û�� ��½� ����� ǥ�� ����:
		<select name="user_type" style="height:19px;padding:0px;" onchange="changeUserType(this.value)">
            <option value="1" selected>��������� </option>
            <option value="2">���ʴ����</option>
            <option value="3">�����</option>
        </select>
	</td>
    </tr>
    <tr>
	<td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td>
			<iframe src="ins_doc_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>
