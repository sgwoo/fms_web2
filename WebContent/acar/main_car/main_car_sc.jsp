<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 5; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function EstiReg()
{	
	var SUBWIN="./esti_mng_i.jsp";	
	window.open(SUBWIN, "EstiReg", "left=100, top=100, width=580, height=200, scrollbars=no");
}

function UpdateList(arg)
{	
	var theForm = document.CarOffUpdateForm;
	theForm.car_off_id.value = arg;
	theForm.target="d_content";
	theForm.submit();
}

	//��ü����
	function AllSelect(){
		var fm = EstiList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}	
	
	//���ð���
	function select_esti(){
		var fm = EstiList.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("������ ������ �����ϼ���.");
			return;
		}	

		if(cnt > 3){
		 	alert("���� �Ǽ��� �����ϴ�. �ִ� 3�� �Դϴ�.");
			return;
		}	

		if(confirm('������ ������ �����Ͻðڽ��ϱ�?')){
			fm.target = "i_no";						
			fm.action = "w_select_car_esti_proc.jsp";
	//		fm.action = "http://cms.amazoncar.co.kr:8080/acar/admin/w_select_car_esti_proc.jsp";   //104�� ����
			fm.submit();	
		}
	}		
//-->
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">    
    <tr> 
      <td>	  
	   <a href="javascript:select_esti();" title='���ð���'>[���ð���]</a> (�ִ� 3�� ���� ����)
	  </td>
    </tr>  
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class="line" width=100%>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td width=3% rowspan="3" class="title">����</td>
                                <td width=3% rowspan="3" class="title"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                                <td width=4% rowspan="3" class="title">�켱<br>����</td>
                                <td width=12% rowspan="3" class="title">����</td>
                                <td width=4% rowspan="3" class="title">���ӱ�<br>/�ſ�</td>
                                <td width=5% rowspan="3" class="title">����</td>
                                <td width=6% rowspan="3" class="title">��������</td>
                                <td width=5% rowspan="3" class="title">DC�ݾ�</td>
                                <td width=3% rowspan="3" class="title">����<br>�ڵ�</td>				
                                <td width=3% rowspan="3" class="title">���<br>����</td>
                                <td width=3% rowspan="3" class="title">���<br>����</td>
                                <td colspan="2" class="title">��ⷻƮ</td>
                                <td colspan="2" class="title">���丮��</td>
                                <td colspan="2" class="title">���丮��</td>				
                                <td width=7% rowspan="3" class="title">����</td>
                            </tr>
                            <tr> 
                                <td class="title">�⺻��</td>
                                <td class="title">�Ϲݽ�</td>
                                <td class="title">�⺻��</td>
                                <td class="title">�Ϲݽ�</td>
                                <td class="title">�⺻��</td>
                                <td class="title">�Ϲݽ�</td>
                            </tr>
                            <tr>
                                <td width=14% colspan="2" class="title">(����� ����)</td>
                                <td width=14% colspan="2" class="title">(����� ����)</td>
                                <td width=14% colspan="2" class="title">(����� ������)</td>
                            </tr>
                        </table>
                    </td>			        
                </tr>
            </table>
        </td>
        <td width='17'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=2>
            <iframe src="./main_car_sc_in.jsp?auth_rw=<%=auth_rw%>&base_dt=<%= base_dt %>&car_comp_id=<%= car_comp_id %>&t_wd=<%= t_wd %>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
        </td>
    </tr>
</table>

</body>
</html>