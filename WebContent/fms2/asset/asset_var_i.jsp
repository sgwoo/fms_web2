<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	bean = a_db.getAssetVarCase(a_a, seq);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(fm.a_a.value == ''){ alert('�ڻ걸���� �����Ͻʽÿ�.'); return;}
		if(fm.a_1.value == ''){ alert('�ڻ�����ڵ带 �Է��Ͻʽÿ�.'); return;}
		if(fm.b_1.value == ''){ alert('�������� �����Ͻʽÿ�.'); return;}
		if(fm.b_2.value == ''){ alert('���뱸���� �����Ͻʽÿ�.'); return;}
		if(fm.c_1.value == ''){ alert('�󰢹���� �����Ͻʽÿ�.'); return;}
		if(fm.d_1.value == ''){ alert('�󰢺������ �Է��Ͻʽÿ�.'); return;}
		
		if(cmd == 'i'){
					
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		}else if(cmd == 'up'){
													
			if(!confirm('�Է��� ����Ÿ�� ���׷��̵��մϴ�.\n\n��¥�� ���׷��̵��Ͻðڽ��ϱ�?')){	return;	}						
		}else{
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
	
	//��Ϻ���
	function go_list(){
		location='asset_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>';
	}

//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form name="form1" method="post" action="asset_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td><font color="navy">MASTER -> �ڵ���� -&gt; </font><font color="red">�ڻ꺯������
        </font></td>
    </tr>
    <tr> 
      <td align="right"> <%if(seq.equals("")){%>
	  <a href="javascript:save('i');">���</a> 
	  <%}else{%>
	  <a href="javascript:save('u');">����</a> 	  
	  <a href="javascript:save('up');">���׷��̵�</a> 	  	  
	  <%}%>
	  <a href="javascript:go_list();">���</a></td>
      </td>
    </tr>
    <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
	       <td width=150 height=22 class=title>�ڻ걸��</td>
	       <td>&nbsp;<select name="a_a">
	                <option value="" >--����--</option>
	                <option value="1" <%if(a_a.equals("1"))%>selected<%%>>��������ڵ���</option>
	                <option value="2" <%if(a_a.equals("2"))%>selected<%%>>��Ʈ����ڵ���</option>
	                </select></td>
	    </tr>
	       <tr bgcolor=#FFFFFF>
            <td height=22 class=title>�ڻ�����ڵ�</td>
            <td>&nbsp;<input type="text" name="a_1" size="10" value='<%=bean.getA_1()%>' class=text ></td>
        </tr>
	   </table>
	  </td>
	</tr>    
     	
    <tr>
	    <td height=22 >1. ������</td>
	</tr>
	  
    <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>������</td>
            <td>&nbsp;<input type="text" name="b_1" size="10" class=num value='<%=bean.getB_1()%>'></td></td>
     	</tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>�������</td>
            <td>&nbsp;<select name="b_2">   
                <option value="">--����--</option>                      
                <option value="1" <%if(bean.getB_2().equals("1"))%>selected<%%>>�������</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>���������</td>
            <td>&nbsp;<input type="text" name="b_3"   value='<%=AddUtil.ChangeDate2(bean.getB_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>������</td>
            <td>&nbsp;<input type="text" name="b_4"   value='<%=AddUtil.ChangeDate2(bean.getB_4())%>'   size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>����</td>
            <td>&nbsp;<textarea name=b_5 cols=100% rows=3><%=bean.getB_5()%></textarea></td>
        </tr>
      </table>
	 </td>
    </tr>
    <tr>
        <td height=25 >&nbsp;</td>
    </tr>
    
    <tr>
        <td height=22 >2. �󰢹��</td>
    </tr>
	  
	<tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>�󰢹��</td>
            <td>&nbsp;<select name="c_1">
                <option value="">--����--</option>                     
                <option value="1" <%if(bean.getC_1().equals("1"))%>selected<%%>>���׹�</option> 
                <option value="2" <%if(bean.getC_1().equals("2"))%>selected<%%>>������</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>����</td>
            <td>&nbsp;<input type="text" name="c_2" size="10" class=num value='<%=bean.getC_2()%>'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>���������</td>
            <td>&nbsp;<input type="text" name="c_3"   value='<%=AddUtil.ChangeDate2(bean.getC_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>������</td>
            <td>&nbsp;<input type="text" name="c_4"   value='<%=AddUtil.ChangeDate2(bean.getC_4())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>����</td>
            <td>&nbsp;<textarea name=c_5 cols=100% rows=3><%=bean.getC_5()%></textarea></td>
        </tr>
	   </table>
	  </td>
	 </tr>
	 <tr>
        <td height=25 >&nbsp;</td>
     </tr>
     <tr>
        <td height=22 >3. �󰢺����</td>
     </tr>
	 
	 <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>�󰢺����</td>
            <td>&nbsp;<select name="d_1">
                <option value="">--����--</option>                     
                <option value="1" <%if(bean.getD_1().equals("1"))%>selected<%%>>������(����)</option> 
                <option value="2" <%if(bean.getD_1().equals("2"))%>selected<%%>>������(�뿩)</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>�󰢺�����ڵ�</td>
            <td>&nbsp;<input type="text" name="d_2" size="10" value='<%=bean.getD_2()%>' class=text ></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>���������</td>
            <td>&nbsp;<input type="text" name="d_3"   value='<%=AddUtil.ChangeDate2(bean.getD_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>������</td>
            <td>&nbsp;<input type="text" name="d_4"   value='<%=AddUtil.ChangeDate2(bean.getD_4())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>����</td>
            <td>&nbsp;<textarea name=d_5 cols=100% rows=3><%=bean.getD_5()%></textarea></td>
        </tr>
	   </table>
	  </td>
	 </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
