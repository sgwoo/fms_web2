<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*,acar.fax_word.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String user_aut2 = "";
	String user_work = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 			= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	user_work 	= user_bean.getUser_work();
	String i_fax =  user_bean.getI_fax();
	String hot_tel =  user_bean.getHot_tel();
	
	//����-������
	Hashtable br1 = c_db.getBranch(br_id);
	
	String br_addr 	= String.valueOf(br1.get("BR_ADDR"));
	String br_tel 	= String.valueOf(br1.get("TEL"));
	String br_fax 	= String.valueOf(br1.get("FAX"));
	
	if(dept_nm.equals("����������")){
		br_tel = "02-392-4242";
		br_fax = "02-3775-4243";
	}
	if(dept_nm.equals("�ѹ���")){
		br_tel = "02-392-4243";
	}
	
	if(!i_fax.equals("")) 	br_fax = i_fax;
	if(!hot_tel.equals("")) br_tel = hot_tel;
	
	//������¹�ȣ
	Fax_wordDatabase f_db = Fax_wordDatabase.getInstance();
	Vector fax = f_db.Fax_word_list(user_id);
	int fax_size = fax.size();
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>FAXĿ��</title>
<style type=text/css>
<!--
.style1 {font-size: 11px}
-->
</style>
<script language='javascript'>
<!--
function PopFax(cmd)
{
	var fm = document.form1;
	
	
	window.open("about:blank", "FaxCover", "left=10, top=10, height=700, width=700, scrollbars=yes, status=yes");	
	
	fm.cmd.value = cmd;	
	fm.target = 'FaxCover';
 	fm.action="fax_cons_view.jsp";	
	fm.submit();
}

function PopFax1(cmd)
{
	var fm = document.form1;
	
	
	window.open("about:blank", "FaxCover", "left=10, top=10, height=700, width=700, scrollbars=yes, status=yes");	
	
	fm.cmd.value = cmd;	
	fm.target = 'FaxCover';
 	fm.action="fax_cons_view_s.jsp";	
	fm.submit();
}

function fax_word_reg(){
		var SUBWIN="fax_word_reg.jsp";	
		window.open(SUBWIN, "fax_word_reg", "left=100, top=100, width=650, height=700, scrollbars=no");
}

function msgDisp(){
		var fm = document.form1;
		fm.memo.value = fm.memo.value+' '+fm.content.value+ "\n\r" ;
//		checklen();
}

 function ok1(){
	var fm = document.form1;
	var j = 0;

		for(i=0; i<fm.gubi1.length; i++){
			if(fm.gubi1[i].checked){
				j++;
				fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi1[i].value+ "\n\r" ;
			}
		}
	}
function ok2(){
 	 var fm = document.form1;
 	 var j = 0;
    for(i=0; i<fm.gubi2.length; i++)
    {
     if(fm.gubi2[i].checked == true)
     {j++;
     	 fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi2[i].value+ "\n\r" ;
     	 
     }
    }
   }
function ok3(){
 	 var fm = document.form1;
 	 var j = 0;
    for(i=0; i<fm.gubi3.length; i++)
    {
     if(fm.gubi3[i].checked == true)
     {j++;
     	 fm.memo.value = fm.memo.value+''+j+'.'+fm.gubi3[i].value+ "\n\r" ;
     }
    }
   }
//textarea �ټ�����
function check_mygreet() 
{ 

var temp; 
var f = form1.memo.value.length; 
var tmpstr = ""; 
var enter = 0; 
var strlen; 

  for(k=0;k<f;k++) 
  { 
  temp = form1.memo.value.charAt(k); 
  
  if(temp == '\n')// �Է� ���� ������ ���� ����Ű Ƚ�� ���� 
  { 
    enter++; 
  } 

  if(enter >= 20) 
  { 
    alert("�Է� �ʰ�!\n 20�� �̻� �Է��Ͻ� �� �����ϴ�."); 
    enter = 0; 
    strlen = tmpstr.length - 1; 
    form1.memo.value = tmpstr.substring(0,strlen); 
    break; 
  } 
  else 
  { 
    tmpstr += temp; 
  } 
  } 
} 

var checkflag = "false";
	
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
//-->
</script>

<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<center>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<table width=640 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=20></td>
    </tr>
    <tr>
        <td><img src=/fms2/off_doc/images/fax01_1.gif></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=640 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> | FAX. <%=br_fax%> </td>
                </tr>
                <tr>
                    <td align=right style='font-size:11px'><b>http://www.amazoncar.co.kr</b></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
    <tr>
        <td align=center>
            <table width=640 border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td height=30>&nbsp;&nbsp;<b><input name=s_com_nm type=text size=31> �� ����</b></td></td>
                    <td align=right><input name=dt type=text size=15 value="<%=AddUtil.getDate3()%>"></td>
                </tr>
                <tr>
                    <td bgcolor=#000000 height=2 colspan=2></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td bgcolor=#FFFFFF colspan=2>
                        <table width=640 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=85 height=30 align=center><b>��&nbsp;��&nbsp;��</b></td>
                                <td width=10><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                                <td width=219>&nbsp;&nbsp;<input name=s_agnt_nm type=text size=31></td>
                                <td width=12>&nbsp;</td>
                                <td width=85 align=center><b>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȣ</b></td>
                                <td width=10><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                                <td width=219>&nbsp;&nbsp;<input name=b_com_nm type=text size=31 value="(��)�Ƹ���ī"></td>
                            </tr>
                            <tr>
                                <td height=30 align=center><b>��ȭ��ȣ</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_tel type=text size=31></td>
                                <td>&nbsp;</td>
                                <td align=center><b>��&nbsp;��&nbsp;��</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_agnt_nm type=text size=31 value="<%=user_nm%>"></td>
                            </tr>
                            <tr>
                                <td height=30 align=center><b>�ѽ���ȣ</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=s_fax type=text size=31></td>
                                <td>&nbsp;</td>
                                <td align=center><b>��ȭ��ȣ<b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_tel type=text size=31 value="<%=hot_tel%>/<%=user_m_tel%>"></td>
                            </tr>
                            <tr>
                                <td height=30 align=center><b>��&nbsp;��&nbsp;��</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td  bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=cnt type=text size=3> �� (ǥ������) </td>
                                <td>&nbsp;</td>
                                <td align=center><b>�ѽ���ȣ</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif></td>
                                <td bgcolor=#FFFFFF>&nbsp;&nbsp;<input name=b_fax type=text size=31 value="<%=br_fax%>"></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td bgcolor=#000000 height=1 colspan=7></td>
                            </tr>
                            <tr>
                                <td height=30 align=center><b>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</b></td>
                                <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                                <td colspan=5>&nbsp;&nbsp;���·ᡤ����ᡤ������� ������ �߱ޱ�� �ȳ�</td>
                            </tr>
                            <tr>
                                <td bgcolor=#000000 height=2 colspan=7></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30></td>
    </tr>
    <tr>
        <td valign=top align=center>
            <table width=620 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top>&nbsp;�����Բ��� ��ó ���� ���� ���·�(�ڵ����������), ���ᵵ�������, ������� ���� ��簡 �������� ����� ��<br>
                      &nbsp;�����ϰ� �����Բ� û���ϰ� �ֽ��ϴ�. ��翡 �����߰ų� ������ ����� ������ �ʿ��Ͻ� ��� <b>�������� ����<br>
                      &nbsp;�Ͻðų� �Ʒ��� ����ó�� ��û</b>�Ͻø� ���α���� ������ ������ �޾ƺ��� �� �ֽ��ϴ�.
                    </td>
                </tr>
                <tr>
		     		<td align=center>
			          	<table width=340 border=0 cellspacing=0 cellpadding=0>
			           		<tr>
			              		<td height=30></td>
			           		</tr>
							<tr>
								<td width=190 height=30>�� <span class=style2>�ѱ����ΰ���</span></td>
								<td width=150>031)426-1281</td>
							</tr>
							<tr>
						   		<td height=30>�� <span class=style2>������ΰ��ӵ���</span></td>
								<td>031)8084-8947~8</td>
							</tr>
							<tr>
								<td height=26>�� <span class=style2>������ӵ��� �ֽ�ȸ��</span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style2>���Ϸο�����</td>
						    	<td>031)994-6400~1</td>
							</tr>
							<tr>
						   		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style2>���ֿ�����</td>
						 		<td>031)894-6300~1</td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style2>�Ҿϻ꿵����</td>
						   		<td>031)522-6300~1</td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style2>���߿�����</td>
						    	<td>031)894-6200~1</td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style2>���翵����</td>
						 		<td>031)994-6300~1</td>
							</tr>
							<tr>
								<td height=30>�� <span class=style2>��⵵ �Ǽ�����</span></td>
								<td>031)429-6067~8</td>
							</tr>
							<tr>
						 		<td height=30>�� <span class=style2>�Ű������̿���(��)</span></td>
						 		<td>032)560-6205</td>
							</tr>

							<tr>
								<td height=30>�� <span class=style2>������ӵ���</span></td>
						 		<td>070-7435-9041</td>
							</tr>
							<tr>
						   		<td height=30>�� <span class=style2>��õ�뱳(��)</span></td>
								<td>032)745-8200,8058</td>
							</tr>
							<tr>
						 		<td height=30>�� <span class=style2>GK �ػ󵵷��ֽ�ȸ��</span></td>
						   		<td>1644-0082</td>
							</tr>
							<tr>
						  		<td height=30>�� <span class=style2>���� ȣ�� ���ð��ӵ���</span></td>
								<td>031)511-7676</td>
							</tr>
							<tr>
						    	<td height=30>�� <span class=style2>��õ�ýü����������̻���</span></td>
						  		<td>032)340-0902,0932,0952</td>
							</tr>
							<tr>
						   		<td height=30>�� <span class=style2>���絵�ð�������</span></td>
						     	<td>031)929-4848</td>
							</tr>
							<tr>
						  		<td height=30>�� <span class=style2>�λ�ü����� ���ȴ�λ����</span></td>
						    	<td>051)780-0078~9</td>
							</tr>
							<tr>
						   		<td height=30>�� <span class=style2>�Ⱦ�� �ü���������</span></td>
						 		<td>031)389-5327,5329,5334</td>
							</tr>
						 	<tr>
								<td height=15></td>
							</tr>			                             			
			       		</table>
			   		</td>
		  		</tr>
                <tr>
                    <td height=15 colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=20 align=center><span class=style1>* ��� �ѽ����뿡 ���� ���ǻ����� �����ø� �߽��ڿ��� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td align=center><a href="javascript:PopFax('view')"><img src=/fms2/off_doc/images/button_see.gif border=0></a>
		&nbsp;&nbsp;&nbsp;<a href="javascript:PopFax('print')"><img src=/fms2/off_doc/images/button_print.gif border=0></a></td>
    </tr>
    <tr>
        <td height=20></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>* ����Ʈ�� ���ͳ� �ͽ��÷ξ� ȭ�� ��ܿ� �޴� �����ϼ���.----------------------------------------</span></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. '����>����������>����(�и�����)' �����¿� 20�� �����Դϴ�.</span></td>
    </tr>	
    <tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. '����>���ͳݿɼ�>����(��ܸǿ���)>�μ�>���� �� �̹��� �μ�'�� üũ �Ǿ� �־�� �ùٸ��� �μ�˴ϴ�.</span></td>
    </tr>
    <tr>
        <td height=20><span class=style1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 20�� �̻��� �������� �Ѿ�� Ȯ���Ͻñ� �ٶ��ϴ�.</span></td>
    </tr>		
</table>
</form>
</center>
</body>
</html>