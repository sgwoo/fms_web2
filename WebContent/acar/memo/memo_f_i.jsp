<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String memo_id = request.getParameter("memo_id")==null?"":request.getParameter("memo_id");
	int count = 0;

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector pr 	= c_db.getUserList("", "", "PR_EMP"); 	//임원 리스트
	Vector ub 	= c_db.getUserList("", "", "BUS_EMP"); 	//영업팀 리스트
	Vector um 	= c_db.getUserList("", "", "MNG_EMP"); 	//고객지원팀 리스트
	Vector ug 	= c_db.getUserList("", "", "GEN_EMP"); 	//총무팀 리스트
	Vector all 	= c_db.getUserList("", "", "ALL_EMP"); 	//전직원 리스트
	Vector b1_all 	= c_db.getUserList("", "B1", "EMP"); 	//부산직원 리스트
	Vector d1_all 	= c_db.getUserList("", "D1", "EMP"); 	//대전직원 리스트
	Vector agent 	= c_db.getUserList("", "", "AGENT"); 	//에이전트 리스트
	Vector call 	= c_db.getUserList("", "", "CALL"); 	//콜센터 리스트
	Vector s2_all 	= c_db.getUserList("", "S2", "EMP"); 	//강남지점 리스트
	Vector g1_all 	= c_db.getUserList("", "G1", "EMP"); 	//대구지점 리스트
	Vector j1_all 	= c_db.getUserList("", "J1", "EMP"); 	//광주지점 리스트
	Vector i1_all 	= c_db.getUserList("", "I1", "EMP"); 	//인천지점 리스트
	Vector k3_all 	= c_db.getUserList("", "K3", "EMP"); 	//수원지점 리스트
	Vector u1_all 	= c_db.getUserList("", "U1", "EMP"); 	//울산지점 리스트
	Vector s3_all 	= c_db.getUserList("", "S3", "EMP"); 	//강서지점 리스트
	Vector s4_all 	= c_db.getUserList("", "S4", "EMP"); 	//구로지점 리스트
	Vector s5_all 	= c_db.getUserList("", "S5", "EMP"); 	//강북지점 리스트
	Vector s6_all 	= c_db.getUserList("", "S6", "EMP"); 	//송파지점 리스트
	
	int pr_size 	= pr.size();
	int ub_size 	= ub.size();
	int um_size 	= um.size();
	int ug_size 	= ug.size();
	int all_size 	= all.size();
	int b1_all_size = b1_all.size();
	int d1_all_size = d1_all.size();
	int agent_size 	= agent.size();
	int call_size 	= call.size();
	int s2_all_size = s2_all.size();
	int g1_all_size = g1_all.size();
	int j1_all_size = j1_all.size();
	int i1_all_size = i1_all.size();
	int k3_all_size = k3_all.size();
	int u1_all_size = u1_all.size();
	int s3_all_size = s3_all.size();
	int s4_all_size = s4_all.size();
	int s5_all_size = s5_all.size();
	int s6_all_size = s6_all.size();

	String pr_emp_id[] = new String[pr.size()];
	String pr_emp_nm[] = new String[pr.size()];
	
	String bus_emp_id[] = new String[ub.size()];
	String bus_emp_nm[] = new String[ub.size()];
	String mng_emp_id[] = new String[um.size()];
	String mng_emp_nm[] = new String[um.size()];
	String gen_emp_id[] = new String[ug.size()];
	String gen_emp_nm[] = new String[ug.size()];
	String all_emp_id[] = new String[all.size()];
	String all_emp_nm[] = new String[all.size()];
	String b1_all_emp_id[] = new String[b1_all.size()];
	String b1_all_emp_nm[] = new String[b1_all.size()];
	String d1_all_emp_id[] = new String[d1_all.size()];
	String d1_all_emp_nm[] = new String[d1_all.size()];
	String agent_emp_id[] = new String[agent.size()];
	String agent_emp_nm[] = new String[agent.size()];
	String call_emp_id[] = new String[call.size()];
	String call_emp_nm[] = new String[call.size()];
	String s2_all_emp_id[] = new String[s2_all.size()];
	String s2_all_emp_nm[] = new String[s2_all.size()];
	String g1_all_emp_id[] = new String[g1_all.size()];
	String g1_all_emp_nm[] = new String[g1_all.size()];
	String j1_all_emp_id[] = new String[j1_all.size()];
	String j1_all_emp_nm[] = new String[j1_all.size()];
	String i1_all_emp_id[] = new String[i1_all.size()];
	String i1_all_emp_nm[] = new String[i1_all.size()];
	String k3_all_emp_id[] = new String[k3_all.size()];
	String k3_all_emp_nm[] = new String[k3_all.size()];
	String u1_all_emp_id[] = new String[u1_all.size()];
	String u1_all_emp_nm[] = new String[u1_all.size()];
	String s3_all_emp_id[] = new String[s3_all.size()];
	String s3_all_emp_nm[] = new String[s3_all.size()];
	String s4_all_emp_id[] = new String[s4_all.size()];
	String s4_all_emp_nm[] = new String[s4_all.size()];
	String s5_all_emp_id[] = new String[s5_all.size()];
	String s5_all_emp_nm[] = new String[s5_all.size()];
	String s6_all_emp_id[] = new String[s6_all.size()];
	String s6_all_emp_nm[] = new String[s6_all.size()];
	
	for (int i = 0 ; i < pr_size ; i++){
		Hashtable user = (Hashtable)pr.elementAt(i);
		pr_emp_id[i] = String.valueOf(user.get("USER_ID"));
		pr_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < ub_size ; i++){
		Hashtable user = (Hashtable)ub.elementAt(i);
		bus_emp_id[i] = String.valueOf(user.get("USER_ID"));
		bus_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < um_size ; i++){
		Hashtable user = (Hashtable)um.elementAt(i);
		mng_emp_id[i] = String.valueOf(user.get("USER_ID"));
		mng_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < ug_size ; i++){
		Hashtable user = (Hashtable)ug.elementAt(i);
		gen_emp_id[i] = String.valueOf(user.get("USER_ID"));
		gen_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < all_size ; i++){
		Hashtable user = (Hashtable)all.elementAt(i);
		all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < b1_all_size ; i++){
		Hashtable user = (Hashtable)b1_all.elementAt(i);
		b1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		b1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < d1_all_size ; i++){
		Hashtable user = (Hashtable)d1_all.elementAt(i);
		d1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		d1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < agent_size ; i++){
		Hashtable user = (Hashtable)agent.elementAt(i);
		agent_emp_id[i] = String.valueOf(user.get("USER_ID"));
		agent_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	for (int i = 0 ; i < call_size ; i++){
		Hashtable user = (Hashtable)call.elementAt(i);
		call_emp_id[i] = String.valueOf(user.get("USER_ID"));
		call_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}
	
	for (int i = 0 ; i < s2_all_size ; i++){
		Hashtable user = (Hashtable)s2_all.elementAt(i);
		s2_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		s2_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}	

	for (int i = 0 ; i < g1_all_size ; i++){
		Hashtable user = (Hashtable)g1_all.elementAt(i);
		g1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		g1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}	
	
	for (int i = 0 ; i < j1_all_size ; i++){
		Hashtable user = (Hashtable)j1_all.elementAt(i);
		j1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		j1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}	
	
	for (int i = 0 ; i < i1_all_size ; i++){
		Hashtable user = (Hashtable)i1_all.elementAt(i);
		i1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		i1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}			

	for (int i = 0 ; i < k3_all_size ; i++){
		Hashtable user = (Hashtable)k3_all.elementAt(i);
		k3_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		k3_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}			

	for (int i = 0 ; i < u1_all_size ; i++){
		Hashtable user = (Hashtable)u1_all.elementAt(i);
		u1_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		u1_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}			
	
	for (int i = 0 ; i < s3_all_size ; i++){
		Hashtable user = (Hashtable)s3_all.elementAt(i);
		s3_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		s3_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}		
	
	for (int i = 0 ; i < s4_all_size ; i++){
		Hashtable user = (Hashtable)s4_all.elementAt(i);
		s4_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		s4_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}		
	
	for (int i = 0 ; i < s5_all_size ; i++){
		Hashtable user = (Hashtable)s5_all.elementAt(i);
		s5_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		s5_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}		
	
	for (int i = 0 ; i < s6_all_size ; i++){
		Hashtable user = (Hashtable)s6_all.elementAt(i);
		s6_all_emp_id[i] = String.valueOf(user.get("USER_ID"));
		s6_all_emp_nm[i] = String.valueOf(user.get("USER_NM"));
	}		
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function send_memo(){
	fm = document.form1;	
	if(fm.title.value == '')		{	alert('제목을 입력하십시오');	fm.title.focus();			return;	}
	if(fm.content.value == '')		{	alert('내용을 입력하십시오');	fm.content.focus();			return;	}
	if(get_length(fm.content.value) > 4000){
		alert("2000자 까지만 입력할 수 있습니다.");
		return;
	}
	
	var obj = fm.lb_userSelectedList;
	fm.rece_id.value = "";
	for(var i=0; i<obj.options.length; i++)
	{
		fm.rece_id.value += " " + obj.options[i].value;
	}	
	
	if(obj.options.length == 0){		alert('받는이를 선택하십시오');	fm.lb_userList.focus();			return;	}
	
	if(!confirm("메모를 보내겠읍니까?")){ return; }	
	fm.action='memo_f_ins.jsp';
	fm.target="i_no";
	fm.submit();	
}

	//부서선택
	function DeptSubID(){
		try{
			var f = form1;
			
			//SelectRemove('ALL');
			
			if(f.dept_id.value == '0001'){			
				var sel_obj = f.lb_userList_0001;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == '0002'){
				var sel_obj = f.lb_userList_0002;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == '0003'){
				var sel_obj = f.lb_userList_0003;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == 'b1'){
				var sel_obj = f.lb_userList_b1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == 'd1'){									
				var sel_obj = f.lb_userList_d1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == 's2'){									
				var sel_obj = f.lb_userList_s2;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == 'g1'){									
				var sel_obj = f.lb_userList_g1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}				
			}else if(f.dept_id.value == 'j1'){									
				var sel_obj = f.lb_userList_j1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}	
				
			}else if(f.dept_id.value == 'i1'){									
				var sel_obj = f.lb_userList_i1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
				
			}else if(f.dept_id.value == 'k3'){									
				var sel_obj = f.lb_userList_k3;
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}				
				
			}else if(f.dept_id.value == 'u1'){									
				var sel_obj = f.lb_userList_u1;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
				
			}else if(f.dept_id.value == 's3'){									
				var sel_obj = f.lb_userList_s3;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}

			}else if(f.dept_id.value == 's4'){									
				var sel_obj = f.lb_userList_s4;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}

			}else if(f.dept_id.value == 's5'){									
				var sel_obj = f.lb_userList_s5;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}

			}else if(f.dept_id.value == 's6'){									
				var sel_obj = f.lb_userList_s6;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
				
												
			}else if(f.dept_id.value == 'agent'){									
				var sel_obj = f.lb_userList_agent;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}
			}else if(f.dept_id.value == 'call'){									
				var sel_obj = f.lb_userList_call;				
				for (var i=0; i<sel_obj.options.length; i++)	{
					sel_obj.options[i].selected = "selected";
				}
				for (var i=0; i<sel_obj.options.length; i++){
					if (sel_obj.options[i].selected){			
						var m_bAdd = false;
						for (var k=0; k<f.lb_userSelectedList.options.length; k++){
							if (f.lb_userSelectedList.options[k].value == sel_obj.options[i].value){
								m_bAdd = true;
								break;
							}
						}
						if (!m_bAdd){
							f.lb_userSelectedList.options.add(new Option(sel_obj.options[i].text, sel_obj.options[i].value));
						}
					}
				}				
			}
		}
		catch (e){
			alert(e.description);
		}	
	}
	
	//전체선택
	function AllSelected(){
		try{
			var f = form1;
			for (var i=0; i<f.lb_userList.options.length; i++)	{
				f.lb_userList.options[i].selected = "selected";
			}
			AddSubID();
		}
		catch (e){
			alert(e.description);
		}
	}
	//선택등록
	function AddSubID(){
		var f = form1;
		if (f.lb_userList.options.selectedIndex == -1){
			alert("사원을 선택하세요.");
			f.lb_userList.focus();
			return;
		};
				
		for (var i=0; i<f.lb_userList.options.length; i++){
			if (f.lb_userList.options[i].selected){		
				if(f.lb_userList.options[i].value.substr(0,1) == '1') continue;	
				var m_bAdd = false;
				for (var k=0; k<f.lb_userSelectedList.options.length; k++){
					if (f.lb_userSelectedList.options[k].value == f.lb_userList.options[i].value){
						m_bAdd = true;
						break;
					}
				}
				if (!m_bAdd){
					f.lb_userSelectedList.options.add(new Option(f.lb_userList.options[i].text, f.lb_userList.options[i].value));
				}
			}
		}
	}
	
	//삭제
	function SelectRemove(tp){
		var obj = form1.lb_userSelectedList;
			
		if (tp == "ALL")
			obj.options.length = 0;
		else{
			if (obj.options.selectedIndex == -1){
				alert("삭제할 항목을 선택하세요.");
				return;
			}
			for (var i=obj.options.length-1; i>=0; i--){
				if (obj.options[i].selected)
					obj.options.remove(i);
			}
		}
	}
//-->
</script>
</head>
<body onLoad="javascript:self.focus()">
<form action="" name="form1" method="post">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="user_pos" value="<%= user_pos %>">
<input type="hidden" name="rece_id" value="">
<input type="hidden" name="rece_nm" value="">
<input type="hidden" name="send_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 메모함 > <span class=style5> 보낼메모 쓰기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
   	<tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="12%" style="min-width:60px;">익명발송</td>
                    <td width=38%>&nbsp; <input type="checkbox" name="anonym_yn" value="Y"></td>
                    <td class=title width="12%" style="min-width:40px;">익명수신</td>
                    <td width=38%>&nbsp; <input type="checkbox" name="anrece_yn" value="Y"></td>
                </tr>		
                <tr> 
                    <td class="title">받는이</td>
                    <td colspan="3"> 
			            <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
			                <tr>
			                    <td class=h></td>
			                </tr>
                            <tr>
                                <td align="center"><img src=../images/center/arrow_bs.gif align=absmiddle>&nbsp;
                                <select name="dept_id" onChange="javascript:DeptSubID()">
                                  <option value="" selected>선택</option>					  
                                  <option value="0001">영업팀</option>
                                  <option value="0002">고객지원팀</option>
                                  <option value="0003">총무팀</option>
                                  <option value="b1">부산지점</option>
                                  <option value="d1">대전지점</option>
                                  <option value="s2">강남지점</option>
                                  <option value="g1">대구지점</option>
                                  <option value="j1">광주지점</option>
                                  <option value="i1">인천지점</option>
                                  <option value="k3">수원지점</option>
                                  <option value="u1">울산지점</option>
                                  <option value="s3">강서지점</option>
                                  <option value="s4">구로지점</option>
                                  <option value="s5">강북지점</option>
                                  <option value="s6">송파지점</option>
                                  <option value="agent">에이전트</option>
                                  <option value="call">콜센타</option>
                                </select></td>
                                <td width=10%>&nbsp;</td>
                                <td width=45% align="center">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td width=45% align="center">
            				    <select size="4" name="lb_userList" multiple="multiple" id="lb_userList" style="height:150px;width:150px;">
								<option value=''>=임원=</option>
									<% for (int i = 0 ; i < pr_size ; i++){%>
                                  <option value='<%=pr_emp_id[i]%>'><%=pr_emp_nm[i]%></option>
                                  <%} %>
            					  <% for (int i = 0 ; i < all_size ; i++){
            					  		//if(all_emp_id[i].substring(0,1).equals("1")) continue;%>
                                  <option value='<%=all_emp_id[i]%>'><%=all_emp_nm[i]%></option>
                                  <%} %>
                                  <option value=''>=콜센타=</option>
                                  <% for (int i = 0 ; i < call_size ; i++){%>
                                  <option value='<%=call_emp_id[i]%>'><%=call_emp_nm[i]%></option>
                                  <%} %>
                                  
            					</select>
                                </td>
            				    <td width=10%><a href="javascript:AddSubID()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=../images/center/button_arrow.gif border=0></a>
                                </td>
            				    <td width=45% align="center">
            				    <select size="4" name="lb_userSelectedList" multiple="multiple" id="lb_userSelectedList" style="height:150px;width:150px;">
            					</select>
                                </td>
                            </tr>
                            <tr> 
                                <td align="center">
            				    <a href="javascript:AllSelected()"><img src=../images/center/button_in_alls.gif border=0 align=absmiddle></a></span>
            				    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:AddSubID()"><img src=../images/center/button_in_sreg.gif border=0 align=absmiddle></a>
                                </td>
            				    <td>
                                </td>
            				    <td align="center">
            				    <a href="javascript:SelectRemove('')"><img src=../images/center/button_in_sdel.gif border=0 align=absmiddle></a>
            				    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:SelectRemove('ALL')"><img src=../images/center/button_in_alldel.gif border=0 align=absmiddle></a>				  
                                </td>
                            </tr>
                            <tr>
			                    <td class=h></td>
			                </tr>
                        </table>
                    </td>
                </tr>		  
                <tr> 
                    <td class="title">제목</td>
                    <td colspan="3"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                            <tr> 
                                <td> <input type="text" name="title" size="87" class=text> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title">내용</td>
                    <td style="height:200" valign="top" colspan="3"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                            <tr> 
                                <td> <textarea name="content" cols='85' rows='13'></textarea> 
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:send_memo();"><img src=../images/center/button_memo_send.gif align=absmiddle border=0></a> <a href="memo_f_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" target="c_body"><img src=../images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr tr id=tr_0001 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_0001" multiple="multiple" id="lb_userList_0001" style="height:50px;width:150px;">
					  <%for (int i = 0 ; i < ub_size ; i++){%>
                      <option value='<%=bus_emp_id[i]%>'><%=bus_emp_nm[i]%></option>
                      <%}%>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_0002 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_0002" multiple="multiple" id="lb_userList_0002" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < um_size ; i++){%>
                      <option value='<%=mng_emp_id[i]%>'><%=mng_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_0003 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_0003" multiple="multiple" id="lb_userList_0003" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < ug_size ; i++){%>
                      <option value='<%=gen_emp_id[i]%>'><%=gen_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_b1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_b1" multiple="multiple" id="lb_userList_b1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < b1_all_size ; i++){ if(b1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=b1_all_emp_id[i]%>'><%=b1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_d1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_d1" multiple="multiple" id="lb_userList_d1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < d1_all_size ; i++){ if(d1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=d1_all_emp_id[i]%>'><%=d1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_s2 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_s2" multiple="multiple" id="lb_userList_s2" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < s2_all_size ; i++){ if(s2_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=s2_all_emp_id[i]%>'><%=s2_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_g1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_g1" multiple="multiple" id="lb_userList_g1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < g1_all_size ; i++){ if(g1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=g1_all_emp_id[i]%>'><%=g1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	    
    <tr tr id=tr_j1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_j1" multiple="multiple" id="lb_userList_j1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < j1_all_size ; i++){ if(j1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=j1_all_emp_id[i]%>'><%=j1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	    
    <tr tr id=tr_i1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_i1" multiple="multiple" id="lb_userList_i1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < i1_all_size ; i++){ if(i1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=i1_all_emp_id[i]%>'><%=i1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	    
    <tr tr id=tr_k3 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_k3" multiple="multiple" id="lb_userList_k3" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < k3_all_size ; i++){ if(k3_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=k3_all_emp_id[i]%>'><%=k3_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	    
    <tr tr id=tr_u1 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_u1" multiple="multiple" id="lb_userList_u1" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < u1_all_size ; i++){ if(u1_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=u1_all_emp_id[i]%>'><%=u1_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_s3 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_s3" multiple="multiple" id="lb_userList_s3" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < s3_all_size ; i++){ if(s3_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=s3_all_emp_id[i]%>'><%=s3_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_s4 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_s4" multiple="multiple" id="lb_userList_s4" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < s4_all_size ; i++){ if(s4_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=s4_all_emp_id[i]%>'><%=s4_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_s5 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_s5" multiple="multiple" id="lb_userList_s5" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < s5_all_size ; i++){ if(s5_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=s5_all_emp_id[i]%>'><%=s5_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_s6 style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_s6" multiple="multiple" id="lb_userList_s6" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < s6_all_size ; i++){ if(s6_all_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=s6_all_emp_id[i]%>'><%=s6_all_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	        
    <tr tr id=tr_agent style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_agent" multiple="multiple" id="lb_userList_agent" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < agent_size ; i++){ if(agent_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=agent_emp_id[i]%>'><%=agent_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	
    <tr tr id=tr_call style='display:none'> 
        <td>&nbsp;<select size="4" name="lb_userList_call" multiple="multiple" id="lb_userList_call" style="height:50px;width:150px;">
					  <% for (int i = 0 ; i < call_size ; i++){ if(call_emp_id[i].substring(0,1).equals("1")) continue;%>
                      <option value='<%=call_emp_id[i]%>'><%=call_emp_nm[i]%></option>
                      <%} %>
					</select>
	    </td>
    </tr>	    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
