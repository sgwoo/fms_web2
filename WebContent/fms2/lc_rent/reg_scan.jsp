<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	//��ĵ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String file_st	 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String file_cont 	= request.getParameter("file_cont")==null?"":request.getParameter("file_cont");
	
	String idx		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String rent_st		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id2 	= request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	
	
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�ڵ帮��Ʈ : ��ེĵ���ϱ���
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		if(fm.file_st.value == ""){	alert("������ ������ �ּ���!");		fm.file_st.focus();	return;		}
		if(fm.file.value == ""){		alert("������ ������ �ּ���!");		fm.file.focus();		return;		}
		
		var str_dotlocation,str_ext,str_low, str_value;
    str_value  			= fm.file.value;
    str_low   			= str_value.toLowerCase(str_value);
    str_dotlocation = str_low.lastIndexOf(".");
    str_ext   			= str_low.substring(str_dotlocation+1);

		if (fm.file_st.value == "38" ) {  //cms ���Ǽ�
				
			if  ( str_ext == 'tif'  ||  str_ext == 'jpg'  || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
				var conStr = "cms ���Ǽ��� ���Ͽ뷮�� 300Kb�� ���ѵ˴ϴ�.";
				if(confirm(conStr)==true){
					
				}else{
					return;
				}
			} else {
				alert("tif  �Ǵ� jpg�� ��ϵ˴ϴ�." );
				return;
			}
			
		}else if (fm.file_st.value == "2" || fm.file_st.value == "4" || fm.file_st.value == "17" || fm.file_st.value == "18" || fm.file_st.value == "10" || fm.file_st.value == "27" || fm.file_st.value == "37" || fm.file_st.value == "15" || fm.file_st.value == "51" || fm.file_st.value == "52") {  //jpg��༭, ����ڵ����, ���ݰ�꼭, �����̿���Ȯ�ο�û��, ����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg, �Ÿ��ֹ���
				
			if  ( str_ext == 'gif'  ||  str_ext == 'jpg'   || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				
			} else {
				alert("jpg  �Ǵ� gif�� ��ϵ˴ϴ�." );
				return;
			}
		}
		

		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		
	
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value+''+fm.file_st.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();
	}
	
//-->
</script>
</head>

<body onload='javascript:document.form1.file_cont.focus();'>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  
  <input type='hidden' name="idx"			value="<%=idx%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">  
  <input type='hidden' name="fee_size" 		value="<%=fee_size%>">    
  <input type='hidden' name="seq" 		value="">
  <input type='hidden' name="copy_path"		value="">
  <input type='hidden' name="copy_type"		value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��ĵ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>
	      <%	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='25%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>���</td>
                    <td>&nbsp;
                      <select name="file_rent_st">					  
                        <option value="1" <%if(fee_size==1){%>selected<%}%>>�ű�</option>
						<%for(int i = 1 ; i < fee_size ; i++){%>
                        <option value="<%=i+1%>" <%if(fee_size==(i+1)){%>selected<%}%>><%=i%>������</option>						
						<%}%>
                      </select>
                    </td>
                </tr>			
                <tr>
                    <td class='title' width='15%'>����</td>
                    <td>&nbsp;
        	      <select name="file_st">
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td>
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(file_st.equals("21")){%>
    <tr>
        <td>�� ���� �ִ� ����Ÿ�� ���躯�湮����ȣ�̴� �������� ������.</td>
    </tr>		
	<%}else if(file_st.equals("22")){%>
    <tr>
        <td>�� ���� �ִ� ����Ÿ�� �뿩�ắ�湮����ȣ�̴� �������� ������.</td>
    </tr>		
	<%}else{%>
    <tr>
        <td>�� 2010��5��1�� ���� �뿩�����İ�༭, ����ڵ����, �ź��� ��ĵ�� JPG�� ���� ������ ��� ��ĵ ����� ���� �ʽ��ϴ�.</td>
    </tr>	
    <tr>
        <td>�� <b>�뿩�����İ�༭(��/��)jpg</b>�� <b>������ȣ, �뿩������, �뿩������</b>�� �ۼ��Ȱ����� ��ĵ�ϼ���.</td>
    </tr>
    <tr>
        <td>�� <b>�ڵ������Լ��ݰ�꼭�� jpg</b>�� ��ĵ����ϼ���.(2012-04-09)</td>
    </tr>			
    <tr>
        <td>�� <b>�Ÿ��ֹ����� jpg</b>�� ��ĵ����ϼ���.(2021-03-16)</td>
    </tr>	
    <tr>
        <td>�� ������� �����ϴ�. ���� �̸��� ����κ� �߰��Ͽ� �����Ͻð� ����Ͻʽÿ�.</td>
    </tr>  		
    <tr>
        <td>�� <b>���ϱ��� �߰���  IT���������� ��û�ϼ���.</b></td>
    </tr>      
    
	<%}%>
    <tr>
        <td align="right">
            <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%//}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
