<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	BankLendBean bl = abl_db.getBankLend(lend_id);
	
	Vector vt =  as_db.getClsBankList(lend_id);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ߵ�����
	function view_cls_list(cls_rtn_dt){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var lend_id = fm.lend_id.value;
		var rtn_seq = fm.rtn_seq.value;
		var url = "";
		url = "../cls_bank/cls_c.jsp?auth_rw="+auth_rw+"&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&cls_rtn_dt="+cls_rtn_dt;
		window.open(url, "CLS_BANK", "left=100, top=180, width=940, height=550, status=yes, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>

<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=980>
    <tr> 
      <td> 
        <table border="0" cellspacing="1" cellpadding="0" width=980>
          <tr> 
            <td align='left'><font color="navy">�繫���� -> ����������</font> -> <font color="red">������� 
              �ߵ���ȯ �̷�</font></td>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class='line2' > 
        <table border="0" cellspacing="1" cellpadding="0" width=980>
          <tr> 
            <td width='90' class='title'>�������ID</td>
            <td width='110'>&nbsp;<%=lend_id%></td>
            <td width='80' class='title'>�����籸��</td>
            <td width='130'>&nbsp;
			  <%if(bl.getCont_bn_st().equals("1")){%>��1������<%}%>
              <%if(bl.getCont_bn_st().equals("2")){%>��2������<%}%>
            </td>
            <td width='80' class='title'>������</td>
            <td width="110">&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
            <td class='title' width="80">������</td>
            <td>&nbsp;<%=bl.getBn_br()%></td>
          </tr>
          <tr> 
            <td class='title' width="90">�����</td>
            <td>&nbsp;<%=bl.getCont_dt()%></td>
            <td class='title' width="80">������</td>
            <td>&nbsp;<%=bl.getLend_int()%>%</td>
            <td class='title' width="80">����ݾ�</td>
            <td colspan='3'>&nbsp;<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>��</td>
          </tr>
                <tr> 
                    <td class=title width=10%>�ߵ���ȯ<br>��������</td>
                    <td width=15%>&nbsp;<%=bl.getCls_rtn_fee_int()%>%</td>
                    <td class=title wwidth=10%>�ߵ���ȯ<br>Ư�̻���</td>
                    <td colspan='5'>&nbsp;<%=bl.getCls_rtn_etc()%></td>                    
                </tr>			  
        </table>
      </td>
    </tr>
    <tr> 
      <td>&lt;&lt; ���� �ߵ���ȯ ���� &gt;&gt;</td>
    </tr>
    <tr> 
      <td class='line2'> 
        <table border="0" cellspacing="1" cellpadding="0" width="980">
          <tr> 
            <td width='30' class='title'>����</td>
            <td width='90' class='title'>������</td>
            <td width='150' class='title'>��������</td>			
            <td width='100' class='title'>�̻�ȯ����</td>
            <td width='100' class='title'>����������ä</td>
            <td width='90' class='title'>������Ա�</td>
            <td width='80' class='title'>����������</td>			
            <td width='80' class='title'>��Ÿ������</td>
            <td width='80' class='title'>�������</td>
            <td width='80' class='title'>��Ÿ�ݾ�</td>			
            <td width='100' class='title'>��ȯ�ݾ�</td>						
          </tr>
		  <%	for(int i = 0 ; i < vt_size ; i++){
				ClsBankBean cls = (ClsBankBean)vt.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:view_cls_list('<%=cls.getCls_rtn_dt()%>');" title='�ߵ���ȯ ����'><%=cls.getCls_rtn_dt()%></a></td>
            <td>&nbsp;<%=cls.getCls_rtn_cau()%></td>
            <td	align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest_1())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getNalt_rest_2())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_etc_fee())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getDly_alt()+cls.getBe_alt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%></td>
          </tr>				
		  <%	}%>		
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
