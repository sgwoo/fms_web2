<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//��ĵ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st		= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	int    fee_size		= request.getParameter("fee_size")==null?1:AddUtil.parseInt(request.getParameter("fee_size"));
	int    h_scan_num	= request.getParameter("h_scan_num")==null?1:AddUtil.parseInt(request.getParameter("h_scan_num"));
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	String content_seq = "";
	String file_st = "";
	String file_rent_st = "";
	String file_cont = "";
	
	String vid1[] 		= request.getParameterValues("ch_l_cd");	
	
	int vid_size 		= vid1.length;
	
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
		
		<%	for(int i=0;i < vid1.length;i++){%>
		if(fm.file[<%=i%>].value == ''){ 
			alert('<%=i+1%>�� ������ �����ϴ�. ������ �����Ͽ� �ֽʽÿ�.'); return;
		}else{
			var str_dotlocation,str_ext,str_low, str_value;
    	str_value  			= fm.file[<%=i%>].value;
    	str_low   			= str_value.toLowerCase(str_value);
    	str_dotlocation = str_low.lastIndexOf(".");
    	str_ext   			= str_low.substring(str_dotlocation+1);
			if (fm.file_st[<%=i%>].value == "38" ) {  //cms ���Ǽ�
				if  ( str_ext == 'tif'  ||  str_ext == 'jpg' || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
					var conStr = "cms ���Ǽ��� ���Ͽ뷮�� 300Kb�� ���ѵ˴ϴ�.";
					if(confirm(conStr)==true){
						
					}else{
						return;
					}
				} else {
					alert("<%=i+1%>�� ���� : tif  �Ǵ� jpg�� ��ϵ˴ϴ�." );
					return;
				}
			}else if (fm.file_st[<%=i%>].value == "2" || fm.file_st[<%=i%>].value == "4" || fm.file_st[<%=i%>].value == "17" || fm.file_st[<%=i%>].value == "18" || fm.file_st[<%=i%>].value == "10" || fm.file_st[<%=i%>].value == "27" || fm.file_st[<%=i%>].value == "37" || fm.file_st[<%=i%>].value == "15" || fm.file_st[<%=i%>].value == "51" || fm.file_st[<%=i%>].value == "52") {  //jpg��༭, ����ڵ����, ���ݰ�꼭, �����̿���Ȯ�ο�û��, ����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg, �Ÿ��ֹ���
				if  ( str_ext == 'gif'  ||  str_ext == 'jpg'  || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				} else {
					alert("<%=i+1%>�� ���� : jpg  �Ǵ� gif�� ��ϵ˴ϴ�." );
					return;
				}
			}
		}		
		<%	}%>
		
		<%	if(vid1.length <12){%>
		<%		for(int i=vid1.length;i < 12;i++){%>
		fm.<%=Webconst.Common.contentSeqName%>[<%=i%>].value = fm.<%=Webconst.Common.contentSeqName%>[<%=i%>].value+''+fm.file_rent_st[<%=i%>].value+''+fm.file_st[<%=i%>].value;
		<%		}%>
		<%	}%>		
				
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="file_cnt" 		value="<%=vid_size%>">    
  <input type='hidden' name="fee_size" 		value="<%=fee_size%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��ĵ�ϰ����</span></span></td>
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
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="10%" class=title>����</td>
                  <td width="10%" class=title>���</td>				  
                  <td width="30%" class=title>����</td>                  
                  <td width="50%" class=title>��ĵ����</td>
                </tr>				
		<%	for(int i=0;i < vid1.length;i++){
				content_seq = vid1[i];				
				file_rent_st 		= content_seq.substring(19,20);
				file_st			= content_seq.substring(20);
		%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center">
			<select name="file_rent_st" >					  
                            <option value="1" <%if(file_rent_st.equals("1")){%>selected<%}%>>�ű�</option>
			    <%	for(int j = 1 ; j < fee_size ; j++){%>
                            <option value="<%=j+1%>" <%if(file_rent_st.equals(String.valueOf(j+1))){%>selected<%}%>><%=j%>������</option>						
			    <%	}%>
                        </select> 
                    </td>
                    <td align="center">
        	        <select name="file_st" >
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>                            
                        </select> 
                    </td>	
                    <td align="center">
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>									
                </tr>	
		<%	}%>	
		<%	if(vid1.length <12){%>
		<%		for(int i=vid1.length;i < 12;i++){
					file_st 	= "5";
					file_cont 	= "";
		%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center">
			<select name="file_rent_st">					  
                            <option value="1" <%if(rent_st.equals("1")){%>selected<%}%>>�ű�</option>
			    <%	for(int j = 1 ; j < fee_size ; j++){%>
                            <option value="<%=j+1%>" <%if(rent_st.equals(String.valueOf(j+1))){%>selected<%}%>><%=j%>������</option>						
			    <%	}%>
                        </select> 			
                    </td>
                    <td align="center">
        	        <select name="file_st"> 
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>            	        	                                                       
                        </select> 			
                    </td>	
                    <td align="center">
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>									
                </tr>	
		<%		}%>			
		<%	}%>	
            </table>
        </td>
    </tr>
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
    
    <tr>
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
</body>
</html>
