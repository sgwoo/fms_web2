<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.secondhand.*, acar.insur.*, acar.memo.*, acar.admin.*,acar.common.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('������ �۾��մϱ�? �� �� �����ϴ�.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'autowork_a.jsp';
		fm.submit();
	}
	
	function popup(url)
	{
		var fm = document.form1;
				
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//������Ȳ
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();	
	
	CodeBean[] banks = c_db.getDebtCptCdAll(); 
	int bank_size = banks.length;
	
	
	int cnt = 0;
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
   	<td colspan=10>
    	      <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>�ܺο�û�ڷ�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
  	</td>
  </tr>
  <tr><td class=h></td></tr>
  <tr><td>&nbsp;</td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ : 
                  <select name="bank_cd">			  
                        <%if(bank_size > 0){
        					for(int i = 0 ; i < bank_size ; i++){
        						CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>'><%= bank.getNm()%></option>
                        <%	}
        				}	%>
                      </select>	  

	  </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
    

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. ����ĳ��Ż  - <b>���м�</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_01.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(���� | ��ȣ | ������	| ���� | ���� | �뿩��� | �Ѵ뿩�� | �ܿ��뿩�� | ���뿩��)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. ����ĳ��Ż  - <b>�뿩����ݽ�����</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_02.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(��� | �Ǽ� | ��������)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. ����ĳ��Ż  - <b>�뿩�Ῥü����Ʈ</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_03.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(���� | ��ȣ | ���� | ������ȣ | ��ü���� | ��ü�ݾ� | ���)
	  </td>
  </tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. ���� �����纰 - <b>�뿩�Ῥü����Ʈ</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_03_2.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(���� | ��ȣ | ���� | ������ȣ | ��ü���� | ��ü�ݾ� | ���)
	  </td>
  </tr>
  <tr><td class=h></td></tr>  
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. �λ�ĳ��Ż  - <b>�߿�����׺��渮��Ʈ</b> : ��ȸ������ �Է� <input type='text' size='11' name='end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>		
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_04.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� | ������ȣ | ����	| ������-����� | ������-������� | ������-����� | ������-������� | ������� | ��������)
	  </td>
  </tr>
  <tr><td class=h></td></tr>

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. �޸���ĳ��Ż - <b>������,����������,�����纰,����������,���Ⱓ��,��ĺ�������Ȳ </b> : ������
		  <select name="end_dt_09">
			  <%if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
							StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			  <option value="<%=sd.getSave_dt()%>"><%=sd.getReg_dt()%></option>		
			  <%	}
					}%>
		  </select>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_09.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ݿ����� : 20180829</td></tr>
  
  <tr><td class=h></td></tr>
  <tr><td><hr></td></tr>
  <tr><td class=h></td></tr>
    
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>�뿩�Ῥü��Ȳ </b> : �ǽð���ȸ
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_05.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� | ����� | ������ȣ | ��ü�ݾ� | �̵����ѱݾ�(��ü������))
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20110517</td></tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>�뿩���⿹����Ȳ (����) </b> : ��ȸ������ �Է� <input type='text' size='11' name='end_dt_06' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_06.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� | ��� | �Ǽ�)
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20110517</td></tr>
  <tr><td class=h></td></tr>
    
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>�뿩���⿹����Ȳ (����) </b> : ��ȸ������ �Է� <input type='text' size='11' name='end_dt_07' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_07.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� | ��� | �Ǽ�)
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20110517</td></tr>
  <tr><td class=h></td></tr>
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b>����������Ȳ </b> : ��ȸ������ �Է� <input type='text' size='11' name='end_dt_08' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-12-31"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_08.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><br>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� | �⵵ | ���� | ��� | �Һδ�� | ���ݴ�� | ���űݾ� | ��漼 | ��Ϻ�� )
	  </td>
  </tr>  
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20130116</td></tr>
  <tr><td class=h></td></tr>

  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. �˻�������  - <b>���м�</b>
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_11.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(���� | �����ȣ | ������ȣ | ���� | ��ȣ | ������	| ���� | ���� | �뿩���� | �뿩������ | �뿩������ | �Ѵ뿩�� | �ܿ��뿩�� | ���뿩�� | ��������� | ������� )
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20200521</td></tr>
  <tr><td class=h></td></tr>  
  
  <tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<% cnt++; %><%=cnt%>. <b> �������� ���ⱸ�� </b> - ����ȣ ���� ��꼭 ������Ȳ  : ��ȸ������ �Է� <input type='text' size='11' name='end_dt_12' maxlength='10' class='default' value='<%=(AddUtil.getDate2(1)-1)+"-01-01"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>����
	      &nbsp;&nbsp;<a href="javascript:popup('outside_req_kdbcapital_12.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		    &nbsp;&nbsp;(���� | ����� | �հ� | ������ | 1���̻� | 1��̸� )
	  </td>
  </tr>
  <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û���� : 20210408</td></tr>
  <tr><td class=h></td></tr>    
  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
