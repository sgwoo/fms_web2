<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.fee.*, acar.insur.*, acar.accid.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>


<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] = request.getParameterValues("ch_cd");
	
	int vid_size 		= 0;
	DocSettleBean doc = null;
	
	vid_size = ch_cd.length;
	
	String doc_type = "";
	String client_st = "";
%>

<html>
<head><title>������ �����û��</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
	
	onprint();
	
function onprint(){
		
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
	}

function IE_Print(){
	factory.printing.header 	= ""; //��������� �μ�
	factory.printing.footer 	= ""; //�������ϴ� �μ�
	factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 12.0; //��������   
	factory.printing.rightMargin 	= 12.0; //��������
	factory.printing.topMargin 	= 30.0; //��ܿ���    
	factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������	
}

<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=30;
		IEPageSetupX.bottomMargin=30;	
		print();
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='600' height="230" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td height="30" align="center"></td>
    </tr>
    <tr> 
      <td height="50" align="center" style="font-size : 18pt;"><b><font face="����">������ �����û��</font></b></td>
    </tr>
    <tr> 
      <td height="50" align='center'></td>
    </tr>
    <tr> 
      <td height="30" style="font-size : 11pt;"><font face="����">��&nbsp;&nbsp;������ ���泻��</font></td>
    </tr>
          <%	
          Hashtable f_cont = new Hashtable();
          for(int i=0;i < vid_size;i++){
		  			//���躯��
					InsurChangeBean d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
					doc = d_db.getDocSettleCommi("48",ch_cd[i]);
					user_bean 	= umd.getUsersBean(doc.getUser_id1());
					
					//���躯�渮��Ʈ
					Vector ins_cha = ins_db.getInsChangeDocList(ch_cd[i]);
					int ins_cha_size = ins_cha.size();
					
					//�����ȸ
					Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
					if(i==0) f_cont = cont;
					
					client_st = cont.get("CLIENT_ST")+""; 
					
					int fee_cng = 0;
					if(d_bean.getD_fee_amt()>0 || d_bean.getD_fee_amt()<0) fee_cng = 1;					
					int opt_cng = 0;
					if(d_bean.getO_opt_amt()-d_bean.getN_opt_amt()>0 || d_bean.getO_opt_amt()-d_bean.getN_opt_amt()<0) opt_cng=1;
					int cls_cng = 0;
					if(d_bean.getO_cls_per()-d_bean.getN_cls_per()>0 || d_bean.getO_cls_per()-d_bean.getN_cls_per()<0) cls_cng=1;
					int rtn_run_cng = 0;
					if(d_bean.getO_rtn_run_amt()-d_bean.getN_rtn_run_amt()>0 || d_bean.getO_rtn_run_amt()-d_bean.getN_rtn_run_amt()<0) rtn_run_cng=2;
					%>    
    <tr bgcolor="#000000"> 
      <td align='center' height="30"> 
	    <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center"> 
            <td style="font-size : 10pt; font-weight:bold;" width="20%"><font face="����">������ȣ</font></td>
            <td style="font-size : 10pt;" width="30%"><font face="����"><%=cont.get("CAR_NO")%></font></td>
            <td style="font-size : 10pt; font-weight:bold;" width="20%"><font face="����">�����Ͻ�</font></td>
            <td style="font-size : 10pt;" width="40%"><font face="����"><%=AddUtil.ChangeDate2(d_bean.getCh_dt())%> 24��</font></td>            		
          </tr>
        </table>
	  </td>
    </tr>
    <%if(ins_cha_size>1){%>
    <tr> 
      <td height="20" align='right'><%if(ins_cha_size>1){%>(<%=ins_cha_size%>��)<%}%></td>
    </tr>
    <%}else{ %>
    <tr> 
      <td height="5" align='right'></td>
    </tr>
    <%} %>
    <%  %>
  </table>
  <table width='600' " border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
      <td width="100%" align='center'>
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center" height="30"> 
            <td style="font-size : 10pt; font-weight:bold" width="20%"><font face="����">����</font></td>
            <td style="font-size : 10pt; font-weight:bold" width="40%"><font face="����">������</font></td>
            <td style="font-size : 10pt; font-weight:bold" width="40%"><font face="����">������</font></td>			
          </tr>	    
          <tr bgcolor="#FFFFFF" align="center"  height="50">          
			<%		for(int j = 0 ; j < ins_cha_size ; j++){
						InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
            <td style="font-size : 10pt; font-weight:bold;" width="20%" ><font face="����">
            	      <%if(cha.getCh_item().equals("1")){%>�뿩��ǰ<%}%>
        	          <%if(cha.getCh_item().equals("2")){%>�뿩������<%}%>
                	  <%if(cha.getCh_item().equals("3")){%>��Ÿ<%}%>
                	  <%if(cha.getCh_item().equals("4")){%>�߰�������<%}%>
					  <%if(cha.getCh_item().equals("5")){%>��������Ÿ�����<%}%>
					  <%if(cha.getCh_item().equals("6")){%>�뿩���Աݿ����Ϻ���<%}%>
					  <%if(cha.getCh_item().equals("7")){%>�������ｺƼĿ�߱�<%}%>
					  <%if(cha.getCh_item().equals("8")){%>������ġ����<%}%>
					  <%if(cha.getCh_item().equals("9")){%>����������<%}%>
			</font></td>
            <td style="font-size : 10pt; " width="40%"><font face="����"><%=cha.getCh_before()%></font>
            <%if(cha.getCh_item().equals("5")){
            		doc_type = "DIST_CNG";
            %>
            km����/1��
            <%}%>
            <%if(rtn_run_cng>0){%>
            <br><span style="font-size:12px;">�̿��� 1km�� <%=AddUtil.parseDecimal(d_bean.getO_rtn_run_amt())%>��(�ΰ�������) ȯ��<br>�ʰ����� 1km�� <%=AddUtil.parseDecimal(d_bean.getO_over_run_amt())%>��(�ΰ�������) ����</span>
            <%} %>
            </td>
            <td style="font-size : 10pt;" width="40%"><font face="����"><%=cha.getCh_after()%></font>
            <%if(cha.getCh_item().equals("5")){%>
            km����/1��
            <%}%>
            <%if(rtn_run_cng>0){ %>
            <br><span style="font-size:12px;">�̿��� 1km�� <%=AddUtil.parseDecimal(d_bean.getN_rtn_run_amt())%>��(�ΰ�������) ȯ��<br>�ʰ����� 1km�� <%=AddUtil.parseDecimal(d_bean.getN_over_run_amt())%>��(�ΰ�������) ����</span>
            <%} %>            
            </td>			
			<%		}%>
          </tr>
           <%		if(fee_cng>0){%>
                <tr bgcolor="#FFFFFF" align="center"  height="50">	
		    <td style="font-size : 10pt; font-weight:bold;" ><font face="����">
					���뿩��
					</font>
		    </td>
		    <td style="font-size : 10pt;" ><font face="����"><%=AddUtil.parseDecimal(d_bean.getO_fee_amt())%>��
		    	<%if(d_bean.getO_fee_amt()>0){%>(vat ����)<%}%>
		    </font></td>
		    <td style="font-size : 10pt;" ><font face="����"><%=AddUtil.parseDecimal(d_bean.getN_fee_amt())%>��
		    	<%if(d_bean.getN_fee_amt()>0){%>(vat ����)<%}%>
		    </font></td>
                </tr>                
                <%		}%>
                
           <%		if(fee_cng>0){%>
                <tr bgcolor="#FFFFFF" align="center"  height="50">	
		    <td style="font-size : 10pt; font-weight:bold;"  ><font face="����">
					���Կɼǰ���
					</font>
		    </td>
		    <td style="font-size : 10pt;" ><font face="����">
		    <% if (d_bean.getO_opt_amt()>0){ %>		    
		        <%=AddUtil.parseDecimal(d_bean.getO_opt_amt())%>��<br>(vat ����)
		    <% } else { %>
		       	���ԿɼǾ���
		    <% } %>  	
		    </font></td>
		    <td style="font-size : 10pt;" ><font face="����">
		    <% if (d_bean.getN_opt_amt()>0){ %>		    
		        <%=AddUtil.parseDecimal(d_bean.getN_opt_amt())%>��<br>(vat ����)
		    <% } else { %>
		       	���ԿɼǾ���
		    <% } %>   
		
		    </font></td>
                </tr>                
                <%		}%>
           <%		if(fee_cng>0){%>
                <tr bgcolor="#FFFFFF" align="center"  height="50">	
		    <td style="font-size : 10pt; font-weight:bold;" ><font face="����">
					�ߵ������������
					</font>
		    </td>
		    <td style="font-size : 10pt;" ><font face="����"><%=d_bean.getO_cls_per()%>%</font></td>
		    <td style="font-size : 10pt;" ><font face="����"><%=d_bean.getN_cls_per()%>%</font></td>
                </tr>                
                <%		}%>                                
                
      </table></td>
    </tr>
<% 	}%>    
  </table>
  <table width='600' height="<%//=height%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan=4 align='center' height="40"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
	  <td align='center' height="20"><font face="����">&nbsp;</font></td>	
      <td colspan=3 style="font-size : 13pt; font-weight:bold;"><font face="����">���� ���� �������� ������ ��û�մϴ�.</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="60"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=4 align='center' style="font-size : 13pt;"><font face="����"><%=AddUtil.getDate3()%></font></td>
    </tr>
    <tr> 
      <td colspan=4 height="80"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
	  <td align='center' width="10%" height="20"><font face="����">&nbsp;</font></td>	
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
      <td align='right' width="70%" style="font-size : 13pt; font-weight:bold;"><font face="����">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="80"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">�� ������ ���濡 ���� �뿩�� ������ �ֽ��ϴ�.</font></td>
    </tr>
    <%if(client_st.equals("1")){ %>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">�� �� ���� ����ڶ��� ���ǰ� ������ �����ϰ� �Ʒ� �ѽ���ȣ�� ȸ�����ֽʽÿ�.</font></td>
    </tr>
    <%}else{%>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">�� �� ���� ����ڶ��� ���ʼ����� �Ʒ� �ѽ���ȣ�� ȸ���� �ֽʽÿ�.</font></td>
    </tr>
    <%} %>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">����� �ѽ���ȣ : <%=user_bean.getUser_nm()%> (FAX <%=user_bean.getI_fax()%>)</font></td>
    </tr>
    <%if(doc_type.equals("DIST_CNG")){ %>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">����� ����ó : <%=user_bean.getUser_nm()%> (TEL <%=user_bean.getUser_m_tel()%>)</font></td>
    </tr>
    <%}else{ %>    
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">��������� : <%=f_cont.get("USER_NM")%> (TEL <%=f_cont.get("USER_M_TEL")%>)</font></td>
    </tr>
    <%} %>
    <tr> 
      <td colspan="4"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align='right'> 
      <td height="40" colspan="4" style="font-size : 13pt; font-weight:bold;"><font face="����"><b>�ֽ�ȸ�� 
        �Ƹ���ī ����</b></font></td>
    </tr>
  </table>
</form>
</body>
</html>
