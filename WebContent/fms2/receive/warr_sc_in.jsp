<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.ext.*, acar.fee.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
  
<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>

	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.ch_cd[i];
			 if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
				if(fm.gi_req_dt[i].value != ''){
					ck.checked =false;
				}
			} 
		} 
	}	

	function cls_guar_enroll(){
		var fm = document.form1;
		var len = fm.elements.length;
	
		var cnt = 0;
		var index, str;
		var idnum="";
		
		var ccnt=	 toInt(parseDigit(fm.cls_size.value));
	
		for(var i=0 ; i<len ; i++){	   
		
			var ck=fm.elements[i];
	//		console.log(i+":" + ck.name);
			if(ck.name == "ch_cd"){				
				if(ck.checked == true){
					idnum=ck.value;					
					index = idnum.indexOf("/");								
					str =  idnum.substring(0, index);														
					var idx = 	 toInt(parseDigit(str));							
					if( ccnt == 1 ){							   					
				//		if(fm.remain_cnt.value != '0')					{ alert('�̼�ä���� �����մϴ�. ����Ϸ�Ȯ�μ��� ����� �� �����ϴ�.'); 					return; }					
					}else{	
				//		if(fm.remain_cnt[idx].value != '0')		{ alert('�̼�ä���� �����մϴ�. ����Ϸ�Ȯ�μ��� ����� �� �����ϴ�.'); 					return; }			
					}									
					cnt++;						
				}
			}		
		}			
				
		if(cnt < 1){
			alert("û���� ���� üũ ���ּ���");
			return;
		} else if ( cnt > 1 ) {
			alert(" �� �� �̻� û���� �� �����ϴ�.");
			return;
		} else {
		   	window.open("about:blank", "SEARCH", "left=100, top=100, width=1000, height=500, scrollbars=yes");
			fm.action = "gua_c.jsp";		
			fm.target="SEARCH";
			fm.submit();		
		
		}
	}
	
	
	//����Ϸ� Ȯ�μ� ���	 - ������������ �Է��� �Ȱ��� ��� �Ұ� 
	function cls_guar_print(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var index, str;
		var idnum="";
					
		var ccnt=	 toInt(parseDigit(fm.cls_size.value));
	  
		var misuCheck = false;
		for(var i=0 ; i<len ; i++){	   
		
			var ck=fm.elements[i];
	//		console.log(i+":" + ck.name);
			if(ck.name == "ch_cd"){				
				if(ck.checked == true){
					idnum=ck.value;					
					index = idnum.indexOf("/");								
					str =  idnum.substring(0, index);														
					var idx = 	 toInt(parseDigit(str));							
					if( ccnt == 1 ){							   					
						if(fm.remain_cnt.value != '0'){ 
							//alert('�̼�ä���� �����մϴ�. ����Ϸ�Ȯ�μ��� ����� �� �����ϴ�.'); 				
							ck.checked =false;
							misuCheck = true;
							cnt--;
						}
						if(fm.gi_req_dt.value != ''){
							ck.checked =false;
							misuCheck = true;
							cnt--;
						}
						
					}else{
						
						if(fm.remain_cnt[idx].value != '0')	{ 
							alert('�̼�ä���� �����մϴ�. ����Ϸ�Ȯ�μ��� ����� �� �����ϴ�.'); 		
							ck.checked =false;
							misuCheck = true;
							cnt--;
						}	
						
						if(fm.gi_req_dt[idx].value != ''){
							ck.checked =false;
							misuCheck = true;
							cnt--;
						}
						
					}									
					cnt++;						
				}
			}		
		}	
		if(misuCheck){
			alert('�̼�ä���� ��ϵ� ���� Ȯ�μ����� ���� �˴ϴ�'); 	
		}
		
		if(cnt < 1){
			alert("����� ���� üũ ���ּ���");
			return;
		} else {
		   	window.open("about:blank", "SEARCH", "left=500, top=0, width=850, height=900, scrollbars=yes");
			fm.action = "warr_sc_print.jsp";		
			fm.target="SEARCH";
			fm.submit();		
					
		}
			
	}	

</script>

</head>

<body>
<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String gubun0 = request.getParameter("gubun0")==null?"1":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	String rent="";
	int total_su = 0;
	
	long total_amt = 0;
	long remain_amt = 0;
	long ctotal_amt = 0;
	long fdtotal_amt = 0;	
	long gtotal_amt = 0;	
	long gptotal_amt = 0;	
	long rtotal_amt = 0;	
				
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	
	//�������� ����Ʈ
	Vector clss = ae_db.getClsFeeScdWarrList(br_id, gubun0, gubun1, gubun2, "1", gubun4, gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int cls_size = clss.size();


%>
<!-- sc���� frame ũ�� ����  height=height+40 -->
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='cls_size' value='<%=cls_size%>'>

<div style="font-size:10pt;">
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	<div class="" id="" style="display:inline-block;margin-left:30px;">
	    <input type="button" id="" class="button" value="û�����" onclick="cls_guar_enroll()"/>
	    <input type="button" id="" class="button btn-submit" value="����Ϸ�Ȯ�μ�" onclick="cls_guar_print()"/>
	</div>
</div> 

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 400px;">
					<div style="width: 400px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
								<td width='20' class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				
			                    <td width='40' class='title title_border'>����</td>	
			                    <td width='40' class='title title_border'>ä��</td>	
				        		<td width='100' class='title title_border'>����ȣ</td>
				        		<td width='120' class='title title_border'>��ȣ</td>
				        		<td width='80' class='title title_border'>������ȣ</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						  <tr> 
		                    <td rowspan="2" width='150' class='title title_border'>����</td>
		                    <td rowspan="2" width='80' class='title title_border'>��������</td>
		                    <td rowspan="2" width='90' class='title title_border'>�Աݿ�����</td>
		                    <td rowspan="2" width='60' class='title title_border'>ȸ��</td>
		                    <td rowspan="2" width='100' class='title title_border'>���������</td>
		                    <td colspan="5" width='450' class='title title_border'>��������</td>
		                    <td rowspan="2" width='100' class='title title_border'>���������<br>�Ա�</td>
		                    <td rowspan="2" width='100' class='title title_border'>�̼���</td>
		                    <td rowspan="2" width='100' class='title title_border'>��������</td>
		                    <td rowspan="2" width='70' class='title title_border'>��ü�ϼ�</td>               
		                    <td rowspan="2" width=70 class='title title_border'>�������</td>
		                </tr>
		                <tr>
		                    <td width='90' class='title title_border'>û����</td>
		                	<td width='90' class='title title_border'>���Աݾ�</td>
		                	<td width='90' class='title title_border'>������</td>
							<td width='90' class='title title_border'>�Աݾ�</td>
							<td width='90' class='title title_border'>�Ա���</td>
		                </tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 400px;">
					<div style="width: 400px;">
						<table class="inner_top_table left_fix">
	
				    		 <%	if(cls_size > 0){%>	   
			         		 <%		for (int i = 0 ; i < cls_size ; i++){
										Hashtable cls = (Hashtable)clss.elementAt(i);
										
										remain_amt =  AddUtil.parseLong(String.valueOf(cls.get("FDFT_AMT"))) - AddUtil.parseLong(String.valueOf(cls.get("PAY_AMT"))) ;   //�̼��ݾ�
																		
										//��ü�� ����
										boolean flag = ae_db.calDelay((String)cls.get("RENT_MNG_ID"), (String)cls.get("RENT_L_CD"));
										%>
			                <tr style="height: 25px;">  
			                   <input type='hidden' name='remain_cnt' value='<%=remain_amt%>'> 
			                  
			                	<td width='20' class='center content_border'>            	
			                	<input type="checkbox" name="ch_cd" value="<%=i%>/<%=cls.get("RENT_MNG_ID")%>/<%=cls.get("RENT_L_CD")%>/<%=cls.get("TM")%>" <% if ( AddUtil.parseLong(String.valueOf(cls.get("GI_REQ_AMT"))) > 0 )  {%> disabled <% } %> ></td>
			                    <td width='40' class='center content_border'><%=i+1%></td><!-- ���� -->
			                    <td width='40' class='center content_border'>                 
			         				<a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','9','<%=cls.get("CR_GUBUN")%>','','')" onMouseOver="window.status=''; return true"><%=cls.get("CR_GUBUN")%></a>
			         			</td><!-- ä�� -->
			                    <td width='100' class='center content_border'><a href="javascript:parent.view_cls('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=cls.get("RENT_L_CD")%></a></td><!-- ����ȣ -->
			                    <td width='120' class='center content_border'><span title='<%=cls.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 7)%></a></span></td><!-- ��ȣ -->
			                    <td width='80' class='center content_border'><span title='<%=cls.get("CAR_NO")%>'>
			                        <%if(String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4") ){%>
				                  			  <b><font color="green"><%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%></font></b>
				                     <% }  else { %>
				                    		<%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%>
				                     <%} %> 
			                    </span></td><!-- ������ȣ -->
			                </tr>
			          <%		}%>
			                <tr>              
			        			     <td class="title content_border center " colspan=6 >�հ�</td>                    
			                </tr>
			            <%} else  {%>  
				           	<tr>
						            <td class='center content_border'>��ϵ� ����Ÿ�� �����ϴ�</td>
						    </tr>	              
				              <%}	%>
				           </table>
				       </div>
				   </td>
				    
				   <td>
					  <div>
						<table class="inner_top_table table_layout">				    
			          <%	if(cls_size > 0){%>	
			      		   <%		for (int i = 0 ; i < cls_size ; i++){
								    Hashtable cls = (Hashtable)clss.elementAt(i);   
								    
								//    if ( AddUtil.parseInt(String.valueOf(cls.get("FDFT_AMT"))) ==  0 ) continue;  //ȯ�Ұ� - ī������� ������ 
								
										ctotal_amt =  AddUtil.parseLong(String.valueOf(cls.get("PAY_AMT"))) ;														
									    if (  AddUtil.parseLong(String.valueOf(cls.get("GI_PAY_AMT"))) > 0 ) {  //�������� �Աݾ��̸� 
								   		    ctotal_amt =   AddUtil.parseLong(String.valueOf(cls.get("PAY_AMT"))) - AddUtil.parseLong(String.valueOf(cls.get("GI_PAY_AMT")));
								   		 }  	
										
										if ( ctotal_amt < 0) ctotal_amt = 0;
								  								   
								   		remain_amt =  AddUtil.parseLong(String.valueOf(cls.get("FDFT_AMT"))) - AddUtil.parseLong(String.valueOf(cls.get("PAY_AMT"))) ;   //�̼��ݾ�
			   					
								 	%>
								 	
								 	 <input type='hidden' name='gi_req_dt' value='<%=cls.get("GI_REQ_DT")%>'> 
			                <tr style="height: 25px;"> 
			                    <td width='150' class='center content_border'><span title='<%=cls.get("CAR_NM")%>'><%=String.valueOf(cls.get("CAR_NM"))%></span></td><!-- ���� -->
			                    <td width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")))%></td><!-- �������� -->
			                    <td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("EST_DT")))%></td><!-- �Աݿ����� -->
			                    <td width='60' class='center content_border'><%=cls.get("TM")%><%=cls.get("TM_ST")%></td><!-- ȸ�� -->
			                    <td width='100' class='right content_border'><%=Util.parseDecimal(String.valueOf(cls.get("FDFT_AMT")))%></td><!-- FDFT_AMT -->
			                   	<td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("GI_REQ_DT")))%></td><!-- �������� �Ա����� -->
			                    <td width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(cls.get("GI_AMT")))%></td><!-- �������� -->
			                    <td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("GI_END_DT")))%></td><!-- �������� ������-->
								<td width='90' class='right content_border'><%=Util.parseDecimal(String.valueOf(cls.get("GI_PAY_AMT")))%></td><!-- �������� �Աݾ� -->
								<td width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("GI_PAY_DT")))%></td><!-- �������� �Ա����� -->
								<td width='100' class='right content_border'><%=Util.parseDecimal(ctotal_amt)%></td><!-- ��������� �Ա� -->
			                    <td width='100' class='right content_border'><%=Util.parseDecimal(remain_amt)%></td><!-- �̼��ݱݾ� -->
			                    <td width='100' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("PAY_DT")))%></td><!-- �������� -->
			                    <td width='70' class='right content_border'><%=cls.get("DLY_DAYS")%>��</td><!-- ��ü�ϼ� -->	                    
			                    <td width='70' class='center content_border'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td><!-- ������� -->
			                </tr>
			          <%
							total_su = total_su + 1;
						
							fdtotal_amt = fdtotal_amt + AddUtil.parseLong(String.valueOf(cls.get("FDFT_AMT")));
							gtotal_amt = gtotal_amt + AddUtil.parseLong(String.valueOf(cls.get("GI_AMT")));
							gptotal_amt = gptotal_amt + AddUtil.parseLong(String.valueOf(cls.get("GI_PAY_AMT")));
							total_amt = total_amt + ctotal_amt;  //��������� �Ա� 
							rtotal_amt = rtotal_amt + remain_amt;  //�̼��� 
									
					  		}%>		  
			                <tr> 
			                    <td class="title content_border">&nbsp;</td><!-- ���� -->
			                    <td class="title content_border">&nbsp;</td><!-- �������� -->	                
			                    <td class="title content_border">&nbsp;</td><!-- �Աݿ����� -->
			                    <td class="title content_border">&nbsp;</td><!-- ȸ�� -->
			                    <td class="title content_border right"><%=Util.parseDecimal(fdtotal_amt)%></td><!-- �ݾ� -->
			                    <td class="title content_border">&nbsp;</td><!-- û������ -->
			                    <td class="title content_border right"><%=Util.parseDecimal(gtotal_amt)%></td><!-- �������� -->
			                    <td class="title content_border">&nbsp;</td><!-- �ձ����� -->
			                    <td class="title content_border right"><%=Util.parseDecimal(gptotal_amt)%></td><!-- �������� �Աݾ�-->	                 
								<td class="title content_border">&nbsp;</td><!-- �Ա����� -->
								<td class="title content_border right"><%=Util.parseDecimal(total_amt)%></td><!-- �������� �Աݾ�-->	        <!-- ����������Ա� -->
								<td class="title content_border right"><%=Util.parseDecimal(rtotal_amt)%></td><!-- �̼��� -->
				                <td class="title content_border">&nbsp;</td><!-- �������� -->
				                <td class="title content_border">&nbsp;</td><!-- ��ü�ϼ� -->    
				                <td class="title content_border">&nbsp;</td><!-- ������� -->  
			                </tr>
					<%} else  {%>  
				           	<tr>
						        <td width="1370" colspan="15"  class='center content_border'>&nbsp;</td>
						    </tr>	              
				    <%}	%>
			            </table>
			        </div>
			    </td>			    
			</tr>
		</table>
	</div>
</div>		    
</form>
</body>
<script>
	document.form1.size.value = '<%=cls_size%>';
</script>
</html>
               
                
 