<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	//���÷��� Ÿ��-��з�
	function cng_input(){
		var fm = document.form1;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '1'){ //�Ⱓ
			td_a.style.display	= '';
			td_b.style.display	= 'none';
		}else if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '2'){ //��Ī
			td_a.style.display	= 'none';
			td_b.style.display	= '';
		}else{
			td_a.style.display	= 'none';
			td_b.style.display	= 'none';
		}
	}	

//���÷��� Ÿ��-�ߺз�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '2'){ //Ư������
			td_a1.style.display	= '';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //��������
			td_a1.style.display	= 'none';
			td_b1.style.display	= '';
			td_c1.style.display	= 'none';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�Ⱓ����
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= '';
			td_d1.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '6'){ //��ȸ�Ⱓ
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_c1.style.display	= 'none';
			td_d1.style.display	= '';
		}else{			
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
			td_a1.style.display	= 'none';
			td_b1.style.display	= 'none';
		}
	}	
	
	//���� ������ ����Ʈ �̵�
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
//		fm.gubun4.value = "";		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/out_car/out_car_frame_a.jsp";
		else if(idx == '2') url = "/fms2/out_car/out_car_frame_b.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='/fms2/out_car/out_car_sc.jsp' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>��ü�����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border='0' cellspacing='1' cellpadding='0' width='100%'>
            	<tr>
					<td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
						<select name='gubun1' onChange="javascript:list_move()">
							<option value="0" <%if(gubun1.equals("0"))%>selected<%%>>����</option>
							<option value="1" <%if(gubun1.equals("1"))%>selected<%%>>�Ⱓ</option>
							<option value="2" <%if(gubun1.equals("2"))%>selected<%%>>��Ī</option>
						</select>
					</td>
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>