<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	//�̼�ä�� ����Ʈ
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ϱ�
	function fine_update(){
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "settle_doc_mng_u_a.jsp";
		fm.submit();
	}	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='s_end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=820>
    <tr> 
      <td><font color="navy">ä�ǰ��� -> </font><font color="red">�ְ������</font></td>
      <td align="right">
	  <a href="javascript:fine_update();" onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;
	  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      <td align="right" width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td class="line" colspan="2" width="800"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="80">������ȣ</td>
            <td><%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title' width="80">��������</td>
            <td><input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
          <tr> 
            <td width="80" rowspan="2" class='title'>����</td>
            <td><%=FineDocBn.getGov_nm()%></td>
          </tr>
          <tr>
            <td><input type="text" name="gov_addr" size="100" class="text" value="<%=FineDocBn.getGov_addr()%>"></td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td><input type="text" name="mng_dept" size="50" class="text" value="<%=FineDocBn.getMng_dept()%>">
			</td>
          </tr>
          <tr> 
            <td class='title' width="80">����</td>
            <td><input type="text" name="title" size="100" class="text" value="<%=FineDocBn.getTitle()%>">
			<!--
			  <select name='title'>
                  <option value='' <%if(FineDocBn.getTitle().equals(""))%>selected<%%>>����</option>
                  <option value="�ְ���"               				<%if(FineDocBn.getTitle().equals("�ְ���"))%>selected<%%>							>�ְ���</option>				  
                  <option value="�����ְ� �� ��������" 				<%if(FineDocBn.getTitle().equals("�����ְ� �� ��������"))%>selected<%%>				>�����ְ� �� ��������</option>				  
				  <option value="���������뺸" 						<%if(FineDocBn.getTitle().equals("���������뺸"))%>selected<%%>						>���������뺸</option>				  
				  <option value="�����뺸" 							<%if(FineDocBn.getTitle().equals("�����뺸"))%>selected<%%>							>�����뺸</option>				  
                  <option value="�����뺸 �� �ߵ������ ���԰���" 	<%if(FineDocBn.getTitle().equals("�����뺸 �� �ߵ������ ���԰���"))%>selected<%%>	>�����뺸 �� �ߵ������ ���԰���</option>
                  <option value="������� �� �����ݳ� �뺸" 		<%if(FineDocBn.getTitle().equals("������� �� �����ݳ� �뺸"))%>selected<%%>		>������� �� �����ݳ� �뺸</option>
                  <option value="��Ÿ" 								<%if(FineDocBn.getTitle().equals("��Ÿ"))%>selected<%%>								>��Ÿ</option>				  				  
               </select>
			   --></td>
          </tr>          
          <tr> 
            <td class='title' width="80">�����Ⱓ</td>
            <td><input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>		
          <tr> 
            <td class='title' width="80">��ĵ</td>
            <td><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><%=FineDocBn.getFilename()%></a>
			<br><input type="file" name="filename2" size="40"></td>
          </tr>		  		  
		    		  
        </table>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td align='right' colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
