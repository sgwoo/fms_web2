<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String sh_code = request.getParameter("sh_code")==null?"":request.getParameter("sh_code");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String disabled = "";
	if(!seq.equals("")) disabled = "disabled";
	
	//�������ܰ�����
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiJgVarCase(sh_code, seq);
	
	//������ �ܰ����� �̷¸���Ʈ
	Vector vt = e_db.getEstiShVarList(sh_code);
	int vt_size = vt.size();
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
		if(fm.sh_code.value == ''){ alert('�����ڵ带 �Է��Ͻʽÿ�.'); return;}
		if(cmd == 'i'){
			if(!confirm('����Ͻðڽ��ϱ�?'))		{	return;	}
		}else if(cmd == 'add'){
			if(!confirm('�߰��Ͻðڽ��ϱ�?'))		{	return;	}		
		}else if(cmd == 'u'){
			if(!confirm('�����Ͻðڽ��ϱ�?'))		{	return;	}		
		}else if(cmd == 'd'){
			if(!confirm('�����Ͻðڽ��ϱ�?'))		{	return;	}		
		}else{
			if(!confirm('���׷��̵��Ͻðڽ��ϱ�?'))	{	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
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
<form name="form1" method="post" action="esti_sh_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="cmd" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td><font color="navy">MASTER -> ������������ -&gt; </font><font color="red">�������ܰ�����
        </font></td>
    </tr>
    <tr> 
      <td align="right">
        <%if(!auth_rw.equals("1")){%> 
        <%    if(seq.equals("")){%>
                <a href="javascript:save('i');">���</a>
        <%    }else{%>
                <a href="javascript:save('u');">����</a> 
		<a href="javascript:save('up');">���׷��̵�</a>
		<a href="javascript:save('d');">����</a>		
        <%    }%>
        <%}%>
      </td>
    </tr>
    <tr>
      <td class=line><table border=0 cellspacing=1 width=700>
        <tr>
          <td width="120" class=title>�����ڵ�</td>
          <td width="580">&nbsp;<input name="sh_code" type="text" class=text id="sh_code" value="<%=bean.getSh_code()%>" size="15"></td>
          </tr>
        <tr>
          <td class=title>����</td>
          <td>&nbsp;<input name="cars" type="text" class=text id="cars" value="<%=bean.getCars()%>" size="50"></td>
          </tr>
        <tr>
          <td class=title>����24�����ܰ���</td>
          <td>&nbsp;<input name="janga24" type="text" class=text id="janga24" value="<%=bean.getJanga24()%>" size="5">
            %</td>
          </tr>
        <tr>
          <td class=title>��������</td>
          <td><table width="100%" border="0" cellpadding="0">
            <tr>
              <td width="25%">¤���� :
                  <input type="checkbox" name="jeep_yn" value="Y" <%if(bean.getJeep_yn().equals("Y"))%>checked<%%>></td>
              <td width="30%">��Ʈ(LPG)���� :
                  <input type="checkbox" name="rentcar" value="Y" <%if(bean.getRentcar().equals("Y"))%>checked<%%>></td>
              <td width="45%">7~9�ν¿��� :
                  <input type="checkbox" name="svn_nn_yn" value="Y" <%if(bean.getSvn_nn_yn().equals("Y"))%>checked<%%>></td>
            </tr>
          </table></td>
          </tr>
        <tr>
          <td class=title>LPG ŰƮ</td>
          <td><table width="100%" border="0" cellpadding="0">
            <tr>
              <td width="25%"><span class="title">�������ɿ���</span> :
                  <input type="checkbox" name="lpg_ga_yn" value="Y" <%if(bean.getLpg_ga_yn().equals("Y"))%>checked<%%>></td>
              <td width="30%">��/Ż����� :
                  <input type="text" name="lpg_amt" value='<%=AddUtil.parseDecimal(bean.getLpg_amt())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
      ��</td>
              <td width="45%">�����л��߰��ݾ� :
                  <input type="text" name="lpg_add_amt" value='<%=AddUtil.parseDecimal(bean.getLpg_add_amt())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
      ��</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td class=title>Ź�۷�</td>
          <td><table width="100%" border="0" cellpadding="0">
            <tr>
              <td width="25%">���� :
                  <input type="text" name="taksong_se" value='<%=AddUtil.parseDecimal(bean.getTaksong_se())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
      ��</td>
              <td width="30%">�λ� :
                  <input type="text" name="taksong_bu" value='<%=AddUtil.parseDecimal(bean.getTaksong_bu())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
      ��</td>
              <td width="45%">&nbsp;</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td class=title>�Һ�
            ������</td>
          <td><table width="100%" border="0" cellpadding="0">
            <tr>
              <td width="25%"><span class="title">12/24����</span> :
                  <input name="af_m12_24" type="text" class=text value="<%=bean.getAf_m12_24()%>" size="5">
      %</td>
              <td width="30%"><span class="title">36����</span> :
                  <input name="af_m36" type="text" class=text value="<%=bean.getAf_m36()%>" size="5">
      %</td>
              <td width="45%"><span class="title">48/60����</span> :
                  <input name="af_m48_60" type="text" class=text value="<%=bean.getAf_m48_60()%>" size="5">
      %</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td class=title>��������</td>
          <td>&nbsp;<input type="text" name="reg_dt" value='<%=AddUtil.ChangeDate2(bean.getReg_dt())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
      </table></td>
    </tr>
<%	if(vt_size > 0){%>	
    <tr>
      <td>&lt; ������ �ܰ����� �̷�&gt;</td>
    </tr>
    <tr>
      <td class="line"><table border=0 cellspacing=1 width=700>
        <tr>
          <td width="30" rowspan="2" class=title>����</td>
          <td width="50" rowspan="2" class=title>24����<br>
            �ܰ���</td>
          <td width="40" rowspan="2" class=title>¤</td>
          <td width="40" rowspan="2" class=title>��Ʈ<br>
            (LPG)</td>
          <td width="40" rowspan="2" class=title>7~9<br>
            �ν�</td>
          <td colspan="3" class=title>LPG</td>
          <td colspan="2" class=title>Ź�۷�</td>
          <td colspan="3" class=title>�Һ�������</td>
          <td width="80" rowspan="2" class=title>��������</td>
        </tr>
        <tr>
          <td width="40" class=title>����<br>
            ����</td>
          <td width="70" class=title>���</td>
          <td width="70" class=title>�����л�</td>
          <td width="60" class=title>����</td>
          <td width="60" class=title>�λ�</td>
          <td width="40" class=title>12/24</td>
          <td width="40" class=title>35</td>
          <td width="40" class=title>48/60</td>
        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>		
        <tr>
          <td align="center"><%=i+1%></td>		
          <td align="center"><%=ht.get("JANGA24")%>%</td>
          <td align="center"><%=ht.get("JEEP_YN")%></td>
          <td align="center"><%=ht.get("RENTCAR")%></td>
          <td align="center"><%=ht.get("SVN_NN_YN")%></td>
          <td align="center"><%=ht.get("LPG_GA_YN")%></td>
          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_AMT")))%>��</td>
          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_ADD_AMT")))%>��</td>
          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_SE")))%>��</td>
          <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_BU")))%>��</td>
          <td align="center"><%=ht.get("AF_M12_24")%>%</td>
          <td align="center"><%=ht.get("AF_M36")%>%</td>
          <td align="center"><%=ht.get("AF_M48_60")%>%</td>
          <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
        </tr>
<%		}%>		
      </table></td>
    </tr>
<%	}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>