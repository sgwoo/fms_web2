<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

	//����ϱ�
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){					alert('������ �����Ͻʽÿ�.'); 					return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');					return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
		
		if(fm.gubun1[5].checked == true){
			if(fm.pay_dt.value == ''){ alert('�ϰ�����ó�� �������ڸ� �Է��Ͻʽÿ�.'); fm.pay_dt.focus(); return; }
			if(fm.est_dt.value == ''){ alert('�ϰ�����ó�� �������ڸ� �Է��Ͻʽÿ�.'); fm.est_dt.focus(); return; }
		}
			
		if(fm.gubun1[0].checked == true){				fm.action = 'excel_renew.jsp';			}
		else if(fm.gubun1[1].checked == true){			fm.action = 'excel_renew_conid.jsp';	}						
		else if(fm.gubun1[2].checked == true){			fm.action = 'excel_renew2.jsp';			}						
		else if(fm.gubun1[3].checked == true){			fm.action = 'excel_renew_conid2.jsp';	}						
		else if(fm.gubun1[4].checked == true){			fm.action = 'excel_pay_20090310.jsp';	}								
		else if(fm.gubun1[5].checked == true){			fm.action = 'excel_pay_20210410_a.jsp';	}
		else if(fm.gubun1[6].checked == true){			fm.action = 'excel_chk.jsp';			}
		else if(fm.gubun1[7].checked == true){			fm.action = 'excel_modify.jsp';			}
		else if(fm.gubun1[8].checked == true){			fm.action = 'excel_blackbox_sms.jsp';	}
		else if(fm.gubun1[9].checked == true){			fm.action = 'excel_blackbox_view.jsp';	}
		else if(fm.gubun1[10].checked == true){			fm.action = 'excel_change.jsp';			}
		else if(fm.gubun1[11].checked == true){			fm.action = 'excel_cls.jsp';			}
		else if(fm.gubun1[12].checked == true){			fm.action = 'excel_change_new.jsp';		}
		else if(fm.gubun1[13].checked == true){			fm.action = 'excel_new.jsp';			}
		else if(fm.gubun1[14].checked == true){			fm.action = 'excel_sync.jsp';			}
		else if(fm.gubun1[15].checked == true){			fm.action = 'excel_sync_save.jsp';		}
		else if(fm.gubun1[16].checked == true){			fm.action = 'excel_hightech_update.jsp';}
		else if(fm.gubun1[17].checked == true){			fm.action = 'excel_firmEmpNm_update.jsp';}
		else if(fm.gubun1[18].checked == true){			fm.action = 'excel_hightech_insUpdate.jsp';}
		else if(fm.gubun1[19].checked == true){			fm.action = 'excel_exp_list.jsp';		}
		else if(fm.gubun1[20].checked == true){			fm.action = 'excel_blackbox_cost.jsp';	}
		else if(fm.gubun1[21].checked == true){			fm.action = 'excel_rate.jsp';			}
		else{			alert('������ �����Ͻʽÿ�.');		return;									}
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		//fm.target = "_blank";
		fm.submit();

	}
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td> <font color="red">[ ���������� �̿��� ���� ó��  ]</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="100" class='title'>����</td>
                    <td>&nbsp;<input type="file" name="filename" size="80"></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;	        
	    </td>
    </tr>    
    <tr>
        <td align="right" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>               
                <tr>
                    <td>	
                        <!-- 0 -->	   
                        <input type="radio" name="gubun1" value="1">
                        <b>������ ���ŵ��1 </b> <font color=red><- �ų� 2��10�� �ϰ���� ó���� (���ź���, ���轺���� ����)</font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">��빰���</td>
                                <td style="font-size : 8pt;" class="title">���ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">������������</td>
                                <td style="font-size : 8pt;" class="title">��д����������</td>
                                <td style="font-size : 8pt;" class="title">���ڱ���������</td>
                                <td style="font-size : 8pt;" class="title">��ִ�ī</td>
                                <td style="font-size : 8pt;" class="title">���Ѻ����</td>
                                <td style="font-size : 8pt;" class="title">�����������뺸��</td>                                
                            </tr>
                        </table>                        
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>      	
                <tr>
                    <td>			   
                        <!-- 1 -->	   
                        <input type="radio" name="gubun1" value="7">
                        <b>������ ���ŵ��2 (�����ȣ, �������ǹ�ȣ) - ���ǹ�ȣ �����ϱ�</b> <font color=red><- �ϰ������ �� ���ǹ�ȣ�� ���� ó���� </font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�缳���ȣ</td>					
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                            </tr>
                        </table>
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  
                <tr>
                    <td>			   
                        <!-- 2 -->	
                        <input type="radio" name="gubun1" value="2">
                        <b>������ ���ŵ�� </b> <font color=red><- �ϰ����ŵ�� ó���� (ȸ����ǥ, ���Ϲ߼� ó�� ����)</font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">��빰���</td>
                                <td style="font-size : 8pt;" class="title">���ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">������������</td>
                                <td style="font-size : 8pt;" class="title">��д����������</td>
                                <td style="font-size : 8pt;" class="title">���ڱ���������</td>
                                <td style="font-size : 8pt;" class="title">��ִ�ī</td>
                                <td style="font-size : 8pt;" class="title">���Ѻ����</td>
                                <td style="font-size : 8pt;" class="title">�����������뺸��</td>                                
                            </tr>
                        </table>
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>			   
                        <!-- 3 -->	
                        <input type="radio" name="gubun1" value="7">
                        <b>������ ���ŵ��2 (�����ȣ, �������ǹ�ȣ) - ���ǹ�ȣ �����ϱ�</b> <font color=red><- �ϰ������ �� ���ǹ�ȣ�� ���� ó���� </font>
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�缳���ȣ</td>					
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                            </tr>
                        </table>                        
                    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <!-- 4 -->	
                        <input type="radio" name="gubun1" value="9">
			            �ϰ� ����ó��(��) (������ Ȯ���� ó��, 10000�� ��������, �ݾ�/���ǹ�ȣ�� ó��)		
			            <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">��̰ᱸ��</td>					
                                <td style="font-size : 8pt;" class="title">�迬��</td>
                                <td style="font-size : 8pt;" class="title">����ù�ȣ</td>
                                <td style="font-size : 10pt;" class="title"><b>��ݾ�</b></td>
                                <td style="font-size : 8pt;" class="title">�븶������</td>
                                <td style="font-size : 8pt;" class="title">�����밳������</td>
                                <td style="font-size : 10pt;" class="title"><b>�����ǹ�ȣ</b></td>
                                <td style="font-size : 8pt;" class="title">���Է�����</td>
                                <td style="font-size : 8pt;" class="title">����</td>
                            </tr>
                        </table>   
  		            </td>
                </tr>			                              
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <!-- 5 -->	
                        <input type="radio" name="gubun1" value="21">
			            <b>�ϰ� ����ó��(��)</b> (���� �о� �ٷ� ó��)	
			            <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 10pt;" class="title"><b>��ݾ�</b></td>
                                <td style="font-size : 10pt;" class="title"><b>�����ǹ�ȣ</b></td>
                            </tr>
                        </table>   	
                        �������� : <input name="pay_dt" type="text" class=text value="" size="10">
                        �������� : <input name="est_dt" type="text" class=text value="" size="10">
  		            </td>
                </tr>			                              
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="10">			
			<b>����翢�� ����</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 NO</td>					
                                <td style="font-size : 8pt;" class="title">2 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">3 ����</td>
                                <td style="font-size : 8pt;" class="title">4 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">5 �ݾ�</td>
                                <td style="font-size : 8pt;" class="title">6 ������</td>
                            </tr>
                        </table>                        
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="12">			
			<b>������ ���Ժ��� ����(�ݾ׺��� �ϰ�ó��)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">����ι��</td>
                                <td style="font-size : 8pt;" class="title">��빰���</td>
                                <td style="font-size : 8pt;" class="title">���ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">������������</td>
                                <td style="font-size : 8pt;" class="title">��д����������</td>
                                <td style="font-size : 8pt;" class="title">���Ѻ����</td>
                                <td style="font-size : 8pt;" class="title">���������</td>
                            </tr>
                        </table>                        
  		    </td>
                </tr>	             
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="13">			
			<b>���ڽ� ������ ���� ����� ���ڹ߼�</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�翬��</td>
                                <td style="font-size : 8pt;" class="title">������ñ�</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	       
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
			<b>���ڽ� ������ ���� ��ȸ</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">�翬��</td>
                                <td style="font-size : 8pt;" class="title">������ñ�</td>
                                <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	 
                  <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
			<b>���� ���� ����</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1.������ȣ</td>
                                <td style="font-size : 8pt;" class="title">2.����</td>
                                <td style="font-size : 8pt;" class="title">3.��ȣ��</td>
                                <td style="font-size : 8pt;" class="title">4.����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">5.�뿩������</td>
                                <td style="font-size : 8pt;" class="title">6.�뿩������</td>
                                <td style="font-size : 8pt;" class="title">7.����������</td>
                                <td style="font-size : 8pt;" class="title">8.����ȸ��</td>
                                <td style="font-size : 8pt;" class="title">9.���������</td>
                                <td style="font-size : 8pt;" class="title">10.���踸����</td>
                            <tr>
                                <td style="font-size : 8pt;" class="title">11.�����ĺ���</td>
                                <td style="font-size : 8pt;" class="title">12.������</td>
                                <td style="font-size : 8pt;" class="title">13.�̰��Խ���</td>
                                <td style="font-size : 8pt;" class="title">14.�����׸�</td>
                                <td style="font-size : 8pt;" class="title">15.������</td>
                                <td style="font-size : 8pt;" class="title">16.������</td>
                                <td style="font-size : 8pt;" class="title">17.�輭������</td>
                                <td style="font-size : 8pt;" class="title">18.��¡�����</td>
                                <td style="font-size : 8pt;" class="title">19.���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">20.���ι��</td>
                            </tr>
                          	<tr>
                                <td style="font-size : 8pt;" class="title">21.���ι��</td>
                                <td style="font-size : 8pt;" class="title">22.�빰���</td>
                                <td style="font-size : 8pt;" class="title">23.�ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">24.������������</td>
                                <td style="font-size : 8pt;" class="title">25.�д����������</td>
                                <td style="font-size : 8pt;" class="title">26.�ڱ���������</td>
                                <td style="font-size : 8pt;" class="title">27.�ִ�ī</td>
                                <td style="font-size : 8pt;" class="title">28.�Ѻ����</td>
                            </tr>    
                        </table>
  		    </td>
                </tr>	                 
                <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="11">
			<b>�ϰ� �����������</b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">��������ȣ</td>
                                <td style="font-size : 8pt;" class="title">�����ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">������</td>
                                <td style="font-size : 8pt;" class="title">�����������߻�����</td>
                                <td style="font-size : 8pt;" class="title">��뵵���泻��</td>
                                <td style="font-size : 8pt;" class="title">��뵵�������</td>
                                <td style="font-size : 8pt;" class="title">��û��/�°�����</td>
                                <td style="font-size : 8pt;" class="title">��ȯ�ޱ�</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                 <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="11">
			<b>���� ���� ����</b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">1.���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2.�輭��ȣ</td>
                                <td style="font-size : 8pt;" class="title">3.�ǰ����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">4.����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">5.�����ָ�</td>
                                <td style="font-size : 8pt;" class="title">6.���Խ�������ȣ</td>
                                <td style="font-size : 8pt;" class="title">7.������ȣ</td>
                                <td style="font-size : 8pt;" class="title">8.����</td>
                                <td style="font-size : 8pt;" class="title">9.����</td>
                                <td style="font-size : 8pt;" class="title">10.�����Ⱓ</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">11.���Թ��</td>
                                <td style="font-size : 8pt;" class="title">12.�г�ȸ��</td>
                                <td style="font-size : 8pt;" class="title">13.�輭�ڵ�</td>
                                <td style="font-size : 8pt;" class="title">14.�輭�׸��</td>
                                <td style="font-size : 8pt;" class="title">15.������</td>
                                <td style="font-size : 8pt;" class="title">16.������</td>
                                <td style="font-size : 8pt;" class="title">17.���Դ㺸</td>
                                <td style="font-size : 8pt;" class="title">18.���ο�</td>
                                <td style="font-size : 8pt;" class="title">19.������</td>
                                <td style="font-size : 8pt;" class="title">20.�빰���</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">21.�ڼ�</td>
                                <td style="font-size : 8pt;" class="title">22.������</td>
                                <td style="font-size : 8pt;" class="title">23.����</td>
                                <td style="font-size : 8pt;" class="title">24.�뿩�ڵ�������</td>
                                <td style="font-size : 8pt;" class="title">25.�ڻ�</td>
                                <td style="font-size : 8pt;" class="title">26.����</td>
                                <td style="font-size : 8pt;" class="title">27.�޾�����</td>
                                <td style="font-size : 8pt;" class="title">28.�д����������</td>
                                <td style="font-size : 8pt;" class="title">29.����������</td>
                                <td style="font-size : 8pt;" class="title">30.��⿩��</td>
                            </tr>
                            <tr>
                            		
                                <td style="font-size : 8pt;" class="title">31.����</td>
                                <td style="font-size : 8pt;" class="title">32.���������</td>
                                <td style="font-size : 8pt;" class="title">33.���������ݾ�</td>
                                <td style="font-size : 8pt;" class="title">34.��������</td>
                                <td style="font-size : 8pt;" class="title">35.���Ա���</td>
                                <td style="font-size : 8pt;" class="title">36.�ű԰���</td>
                                <td style="font-size : 8pt;" class="title">37.��������</td>
                                <td style="font-size : 8pt;" class="title">38.�輭������</td>
                                <td style="font-size : 8pt;" class="title">39.�㺸�������</td>
                                <td style="font-size : 8pt;" class="title">40.���ο�</td>
                            </tr>
                            <tr>
                                <td style="font-size : 8pt;" class="title">41.������</td>
                                <td style="font-size : 8pt;" class="title">42.�빰���</td>
                                <td style="font-size : 8pt;" class="title">43.�ڼ�</td>
                                <td style="font-size : 8pt;" class="title">44.������</td>
                                <td style="font-size : 8pt;" class="title">45.����</td>
                                <td style="font-size : 8pt;" class="title">46.�뿩�ڵ�������</td>
                                <td style="font-size : 8pt;" class="title">47.�ڻ�</td>
                                <td style="font-size : 8pt;" class="title">48.����</td>
                                <td style="font-size : 8pt;" class="title">49.�޾�����</td>
                                <td style="font-size : 8pt;" class="title">50.�д����������</td>
                             </tr>
                             <tr>
                                <td style="font-size : 8pt;" class="title">51.����������</td>
                                <td style="font-size : 8pt;" class="title">52.�����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">53.�����ڼ���</td>
                                <td style="font-size : 8pt;" class="title">54.�����ȣ</td>
                                <td style="font-size : 8pt;" class="title">55.�����������ñ�</td>
                                <td style="font-size : 8pt;" class="title">56.��������������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                 <tr>
                    <td class=h></td>
                </tr>  			
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="12">
			<b>����ī�������� ���� ���� (�ű�) </b>
			 <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                 <td style="font-size : 8pt;" class="title">1.���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2.�輭��ȣ</td>
                                <td style="font-size : 8pt;" class="title">3.�ǰ����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">4.����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">5.�����ָ�</td>
                                <td style="font-size : 8pt;" class="title">6.���Խ�������ȣ</td>
                                <td style="font-size : 8pt;" class="title">7.������ȣ</td>
                                <td style="font-size : 8pt;" class="title">8.����</td>
                                <td style="font-size : 8pt;" class="title">9.����</td>
                                <td style="font-size : 8pt;" class="title">10.�����Ⱓ</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">11.���Թ��</td>
                                <td style="font-size : 8pt;" class="title">12.�г�ȸ��</td>
                                <td style="font-size : 8pt;" class="title">13.�輭�ڵ�</td>
                                <td style="font-size : 8pt;" class="title">14.�輭�׸��</td>
                                <td style="font-size : 8pt;" class="title">15.������</td>
                                <td style="font-size : 8pt;" class="title">16.������</td>
                                <td style="font-size : 8pt;" class="title">17.���Դ㺸</td>
                                <td style="font-size : 8pt;" class="title">18.���ο�</td>
                                <td style="font-size : 8pt;" class="title">19.������</td>
                                <td style="font-size : 8pt;" class="title">20.�빰���</td>
                            </tr>
                            <tr>
                            		<td style="font-size : 8pt;" class="title">21.�ڼ�</td>
                                <td style="font-size : 8pt;" class="title">22.������</td>
                                <td style="font-size : 8pt;" class="title">23.����</td>
                                <td style="font-size : 8pt;" class="title">24.�뿩�ڵ�������</td>
                                <td style="font-size : 8pt;" class="title">25.�ڻ�</td>
                                <td style="font-size : 8pt;" class="title">26.����</td>
                                <td style="font-size : 8pt;" class="title">27.�޾�����</td>
                                <td style="font-size : 8pt;" class="title">28.�д����������</td>
                                <td style="font-size : 8pt;" class="title">29.����������</td>
                                <td style="font-size : 8pt;" class="title">30.��⿩��</td>
                            </tr>
                            <tr>
                            		
                                <td style="font-size : 8pt;" class="title">31.����</td>
                                <td style="font-size : 8pt;" class="title">32.���������</td>
                                <td style="font-size : 8pt;" class="title">33.���������ݾ�</td>
                                <td style="font-size : 8pt;" class="title">34.��������</td>
                                <td style="font-size : 8pt;" class="title">35.���Ա���</td>
                                <td style="font-size : 8pt;" class="title">36.�ű԰���</td>
                                <td style="font-size : 8pt;" class="title">37.��������</td>
                                <td style="font-size : 8pt;" class="title">38.�輭������</td>
                                <td style="font-size : 8pt;" class="title">39.�㺸�������</td>
                                <td style="font-size : 8pt;" class="title">40.���ο�</td>
                            </tr>
                            <tr>
                                <td style="font-size : 8pt;" class="title">41.������</td>
                                <td style="font-size : 8pt;" class="title">42.�빰���</td>
                                <td style="font-size : 8pt;" class="title">43.�ڼ�</td>
                                <td style="font-size : 8pt;" class="title">44.������</td>
                                <td style="font-size : 8pt;" class="title">45.����</td>
                                <td style="font-size : 8pt;" class="title">46.�뿩�ڵ�������</td>
                                <td style="font-size : 8pt;" class="title">47.�ڻ�</td>
                                <td style="font-size : 8pt;" class="title">48.����</td>
                                <td style="font-size : 8pt;" class="title">49.�޾�����</td>
                                <td style="font-size : 8pt;" class="title">50.�д����������</td>
                             </tr>
                             <tr>
                                <td style="font-size : 8pt;" class="title">51.����������</td>
                                <td style="font-size : 8pt;" class="title">52.�����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">53.�����ڼ���</td>
                                <td style="font-size : 8pt;" class="title">54.�����ȣ</td>
                                <td style="font-size : 8pt;" class="title">55.�����������ñ�</td>
                                <td style="font-size : 8pt;" class="title">56.��������������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="13">			
						<b>���� ������ ���� ���ϱ�</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">3 ��ȣ</td>
                                <td style="font-size : 8pt;" class="title">4 ����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">5 ����</td>
                                <td style="font-size : 8pt;" class="title">6 �빰����</td>
                                <td style="font-size : 8pt;" class="title">7 ������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="14">			
						<b>���� ����ȭ �۾�</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- ���ǹ�ȣ	������ȣ	�����ȣ	����	����ڹ�ȣ	���������	���踸����	����Ư��	����������  -->
                                <td style="font-size : 8pt;" class="title">1 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">3 �����ȣ</td>
                                <td style="font-size : 8pt;" class="title">4 ����</td>
                                <td style="font-size : 8pt;" class="title">5 ����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">6 ���������</td>
                                <td style="font-size : 8pt;" class="title">7 ���踸����</td>
                                <td style="font-size : 8pt;" class="title">8 ����Ư��</td>
                                <td style="font-size : 8pt;" class="title">9 ����������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  	
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="15">			
						<b>÷�ܻ������ ������ ������Ʈ(cont_etc)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- ���ǹ�ȣ	������ȣ	�����ȣ	����	����ڹ�ȣ	���������	���踸����	����Ư��	����������  -->
                                <td style="font-size : 8pt;" class="title">1 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">2 ���ʵ����</td>
                                <td style="font-size : 8pt;" class="title">3 ������Ż(������)LKAS</td>
                                <td style="font-size : 8pt;" class="title">4 ������Ż(�����)LDWS</td>
                                <td style="font-size : 8pt;" class="title">5 �������(������)AEB</td>
                                <td style="font-size : 8pt;" class="title">6 �������(�����)FCW</td>
                                <td style="font-size : 8pt;" class="title">7 �����ڵ���EV</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="16">			
						<b>������ ���� ������Ʈ(insur firm_emp_nm)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td style="font-size : 8pt;" class="title">1 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2 ��ȣ</td>
                                <td style="font-size : 8pt;" class="title">3 ����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">4 ����</td>
                                <td style="font-size : 8pt;" class="title">5 �빰</td>
                                <td style="font-size : 8pt;" class="title">6 ������</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="17">			
						<b>÷�ܻ������ ������ ������Ʈ(insur)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- ���ǹ�ȣ	������ȣ	�����ȣ	����	����ڹ�ȣ	���������	���踸����	����Ư��	����������  -->
                                <td style="font-size : 8pt;" class="title">1 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">2 ���������</td>
                                <td style="font-size : 8pt;" class="title">3 ������Ż(������)LKAS</td>
                                <td style="font-size : 8pt;" class="title">4 ������Ż(�����)LDWS</td>
                                <td style="font-size : 8pt;" class="title">5 �������(������)AEB</td>
                                <td style="font-size : 8pt;" class="title">6 �������(�����)FCW</td>
                                <td style="font-size : 8pt;" class="title">7 �����ڵ���EV</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="18">			
						<b>���⸮��Ʈ</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No ������ȣ	�ǰ����ڸ�	�����Ⱓ	����Ư��	�г����	����	���Դ㺸	������	������Ư��	���ǹ�ȣ  -->
                                <td style="font-size : 8pt;" class="title">1 No</td>
                                <td style="font-size : 8pt;" class="title">2 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">3 �ǰ����ڸ�</td>
                                <td style="font-size : 8pt;" class="title">4 �����Ⱓ</td>
                                <td style="font-size : 8pt;" class="title">5 ����Ư��</td>
                                <td style="font-size : 8pt;" class="title">6 �г����</td>
                                <td style="font-size : 8pt;" class="title">7 ����</td>
                                <td style="font-size : 8pt;" class="title">8 ���Դ㺸</td>
                                <td style="font-size : 8pt;" class="title">9 ������</td>
                                <td style="font-size : 8pt;" class="title">10 ������Ư��</td>
                                <td style="font-size : 8pt;" class="title">11 ���ǹ�ȣ</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  		
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="19">			
						<b>�Ｚȭ�� ���ڽ� ����� �����(excel_blackbox_cost)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No ������ȣ	�ǰ����ڸ�	�����Ⱓ	����Ư��	�г����	����	���Դ㺸	������	������Ư��	���ǹ�ȣ  -->
                                <td style="font-size : 8pt;" class="title">1 ����</td>
                                <td style="font-size : 8pt;" class="title">2 ��������</td>
                                <td style="font-size : 8pt;" class="title">3 ����</td>
                                <td style="font-size : 8pt;" class="title">4 ����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">5 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">6 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">7 ���ι��1</td>
                                <td style="font-size : 8pt;" class="title">8 ���ι��2</td>
                                <td style="font-size : 8pt;" class="title">9 �빰���</td>
                                <td style="font-size : 8pt;" class="title">10 �ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">11 �������ڵ��������ѻ���</td>
                                <td style="font-size : 8pt;" class="title">12 �����ܵ������</td>
                                <td style="font-size : 8pt;" class="title">13 �ٸ��ڵ���������������Ư�����</td>
                                <td style="font-size : 8pt;" class="title">14 �����ȣ</td>
                                <td style="font-size : 8pt;" class="title">15 ���ڽ� ���κ����</td>
                            </tr>
                        </table>
  		    </td>
                </tr>	
                <tr>
                    <td class=h></td>
                </tr>  	
                <tr>
                    <td>
                        <input type="radio" name="gubun1" value="20">			
						<b>���������輭(excel_rate)</b> 
                        <table border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <!-- No ������ȣ	�ǰ����ڸ�	�����Ⱓ	����Ư��	�г����	����	���Դ㺸	������	������Ư��	���ǹ�ȣ  -->
                                <td style="font-size : 8pt;" class="title">1 ����</td>
                                <td style="font-size : 8pt;" class="title">2 ��������</td>
                                <td style="font-size : 8pt;" class="title">3 ����</td>
                                <td style="font-size : 8pt;" class="title">4 ����ڹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">5 ������ȣ</td>
                                <td style="font-size : 8pt;" class="title">6 ���ǹ�ȣ</td>
                                <td style="font-size : 8pt;" class="title">7 ���ι��1</td>
                                <td style="font-size : 8pt;" class="title">8 ���ι��2</td>
                                <td style="font-size : 8pt;" class="title">9 �빰���</td>
                                <td style="font-size : 8pt;" class="title">10 �ڱ��ü���</td>
                                <td style="font-size : 8pt;" class="title">11 �������ڵ��������ѻ���</td>
                                <td style="font-size : 8pt;" class="title">12 �����ܵ������</td>
                                <td style="font-size : 8pt;" class="title">13 �ٸ��ڵ���������������Ư�����</td>
                                <td style="font-size : 8pt;" class="title">14 �����ȣ</td>
                                <td style="font-size : 8pt;" class="title">15 �������� �� �����</td>
                            </tr>
                        </table>		                                                
  		    </td>
                </tr>	
                    			                		                             
            </table>
	</td>
    </tr>	      
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	</td>
    </tr>
</table>
</form>
</center>
</body>
</html>
